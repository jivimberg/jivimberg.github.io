---
layout: post
title: "SQS consumer using Kotlin coroutines"
date: 2019-02-23 16:52:48 -0300
comments: true
categories: SQS queue consumer AWS Kotlin coroutines producer
---

Today we’ll see how to write a SQS consumer that processes messages in a parallel, non-blocking way, using Kotlin coroutines. 

<!--more-->

## The pool of workers pattern

After some experimentation I’ve opted for using a _pool of workers_ for writing the consumer. For an introduction on the pattern and how to implement it in Kotlin I strongly suggested watching Roman’s talk from 2018 Kotlin Conf.

<div style="text-align: center;">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/a3agLJQ6vt8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

For our particular solution we’ll need:

1. One coroutine that periodically retrieves the messages (**MsgReceiver**).
2. Multiple **workers** that process the receiving messages in parallel without blocking.
3. A **channel** to communicate between the _MsgReceiver_ coroutine and the _Workers_.

{% img center /images/posts/2019-03-10/consumerDiagram.png 800 ‘SQS consumer diagram’ %} 

### _fun start()_

Let’s start by creating the elements we mentioned in the previous section. We’ll do this in the `start()` method.

<xmp class="kotlin-code" data-highlight-only theme="darcula">
fun start() = launch {
        val messageChannel = Channel<Message>()
        repeat(N_WORKERS) { launchWorker(messageChannel) }
        launchMsgReceiver(messageChannel)
    }
</xmp>

This function launches a coroutine that creates: the channel, _N_ _workers_ and the _MsgReceiver_.  

Don’t worry too much about how we’re able to call `launch` here. I’ll go back to this later. 

### Message receiver

Now it’s time to write the code for the message receiver:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
private fun CoroutineScope.launchMsgReceiver(channel: SendChannel<Message>) = launch {
	    runForever {
	        val receiveRequest = ReceiveMessageRequest.builder()
	                .queueUrl(SQS_URL)
	                .waitTimeSeconds(20)
	                .maxNumberOfMessages(10)
	                .build()
	
	        val messages = sqs.receiveMessage(receiveRequest).await().messages()
	        println("${Thread.currentThread().name} Retrieved ${messages.size} messages")
	
	        messages.forEach {
	            channel.send(it)
	        }
	    }
	}
</xmp>

This function takes a `SendChannel` that it’ll use to communicate with the _worker_ coroutines.

It is written as a `CoroutineScope` to denote that it creates a new coroutine and does not wait for it to complete.

Next thing you’ll notice is that all the code is wrapped with a `runForever`. This is a helper function that will loop our code block infinitely and make sure it keeps running even in the face of exceptions. Here’s the code:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
internal inline fun runForever(block: () -> Unit): Nothing {
	while (true) {
	    try {
	        block()
	    } catch (ex: Exception) {
	        println("${Thread.currentThread().name} failed with exception. Retrying...")
	        ex.printStackTrace()
	        continue
	    }
	}
} 
</xmp>

We’ll use this little trick on our _Worker_ code too. Having the try/catch guarantees the coroutine will keep looping even if the block throws an exception (like a connection timeout reading messages from the queue, for example).
 
An elegant detail is that the return type of `runForever` is `Nothing`[^1]. That tells the Kotlin compiler that we don’t expect the function call to ever return. If, by mistake, we write any other statement after `runForever` the compiler (or the IDE) will warn us about it.

Ok, back to our `launchMsgReceiver` function!  The next part is the actual polling for messages. You’ll notice that I’m maxing out the `waitTimeSeconds`  so the call waits up to _20 seconds_, for at least one message to be available before returning empty. I’m also picking the biggest value for the number of messages being retrieved at once (10), because the whole point of my consumer is to be able to process as many of them in parallel, as possible.

Next line is the `receiveMessage` call on the SQS client. One extremely important detail is that **I’m using the `SqsAsyncClient` from [AWS Java SDK v2][1]**. Why? Because I don’t want my thread to be blocked waiting for messages to appear. And the `SqsAsyncClient` of Java SKD v1 returns only a `Future` (because it needs to be compatible with Java 1.6) making it harder to integrate with the coroutines world. Instead, the new version returns `CompletableFuture`, which lets us call `await()` (from [Kotlinx Coroutines JDK8][2]) to suspend our coroutine until the result is ready **without blocking the thread**.

Finally we iterate over the messages and send them through the channel using  `channel.send(it)` . Because of the way [unbuffered channels][3] work the `send` call will suspend if there is no worker available to receive the message. This is a very nice property because it means **we get [_backpressure_][4] for free**. If at some point our workers are not able to process the messages fast enough, the _MsgReceiver_ will just wait (suspend) until some worker becomes available, instead of fetching even more messages, drowning the workers. 

### Worker

Now let’s take a look at the worker that will process the messages:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
internal inline fun runForever(block: () -\> Unit): Nothing {
 private fun CoroutineScope.launchWorker(channel: ReceiveChannel<Message>) = launch {
	    runForever {
	        for (msg in channel) {
	            try {
	                processMsg(msg)
	                deleteMessage(msg)
	            } catch (ex: Exception) {
	                println("${Thread.currentThread().name} exception trying to process message ${msg.body()}")
	                ex.printStackTrace()
	                changeVisibility(msg)
	            }
	        }
	    }
	}
</xmp>

The first lines are pretty similar to the _MsgReceiver_. We’re again launching a coroutine and not waiting for it to complete, and thus we have the `launch` call and our function is an extension of `CoroutineScope`. We’re also wrapping everything in a `runForever` for the same reasons we used it before. The only difference you might notice is that it takes a `ReceiveChannel` instead of `SendChannel`, because this is the receiving end of the communication.

Next we use a `for` loop to consume messages from the channel. It will suspend the coroutine if there are no new messages in the channel. The use of `for` is important because we’re doing [fan-out][5], we have multiple coroutines consuming from the same channel. Consuming with `for` guarantees us that if one coroutine fails it won’t cancel the underlying channel, which is what would happen if we had used `consumeEach` to go through the messages, instead.

Also channels have the nice property of [being fair][6]. Meaning that the first coroutine that invoke `receive` gets the message. FIFO style.

If something fails while processing the message we (try to) [change the visibility timeout][7] so that the message will show up in the queue again sooner, and picked up for re-processing.

Let’s now take a look at _processMessage(msg)_ implementation:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
private suspend fun processMsg(message: Message) {
        println("${Thread.currentThread().name} Started processing message: ${message.body()}")
        delay((1000L..2000L).random())
        println("${Thread.currentThread().name} Finished processing of message: ${message.body()}")
    }
</xmp>

As you can tell, this is a mock implementation. There’s nothing interesting happening here. We just `delay` for a few seconds and then continue saying that message has been processed. This is where you’d put your actual logic. Or better yet, if you plan to reuse your SQS consumer implementation **you might want to turn this into a Lambda expression that can be passed as a parameter**.

Finally let’s see _deleteMsg(msg)_ and _changeVisibility(msg)_:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
private suspend fun deleteMessage(message: Message) {
        sqs.deleteMessage { req ->
            req.queueUrl(SQS_URL)
            req.receiptHandle(message.receiptHandle())
        }.await()
        println("${Thread.currentThread().name} Message deleted: ${message.body()}")
    }

    private suspend fun changeVisibility(message: Message) {
        sqs.changeMessageVisibility { req ->
            req.queueUrl(SQS_URL)
            req.receiptHandle(message.receiptHandle())
            req.visibilityTimeout(10)
        }.await()
        println("${Thread.currentThread().name} Changed visibility of message: ${message.body()}")
    }
</xmp>

This 2 methods follow the same pattern: call the `SQSAsyncClient` corresponding method then `await()`, finally log.

### Contexts, dispatchers and supervisors

Now that we have a good grasp on the different parts of our solution, let’s pay closer attention to how the coroutines are created and dispatched.

One of the central tenets of Kotlin coroutines is _[structured concurrency][8]_. _Structured concurrency_ helps us write code that properly cleans up active coroutines in case of exceptions. If you think you’re a hardcore developer and instead launch your coroutines using `GlobalScope.launch { ... }`, then you risk leaking coroutines when something fails (check [@relizarov][9]’s [article][10] to see an example of this). So, how’s are our coroutines structured?

{% img center /images/posts/2019-03-10/coroutinesScope.png 400 ‘coroutines structure’ %}  

To mark the lifecycle of our coroutines we extend our class with `CoroutineScope` and provide a context by overriding `corroutinesContext: CorroutineContext`. This is the context that’ll be used by our root coroutine, the one started by the `launch` call on the `start()` function, at the beginning of this post. Since we want our coroutines to match the lifecycle of our class we’ve added a `close()` method that clients can call to cancel all the coroutines in the consumer. If you’re using some kind of framework you might want to tie this function the lifecycle of the class in some other way. 

<xmp class="kotlin-code" data-highlight-only theme="darcula">
package com.jivimberg.sqs

import kotlinx.coroutines.*
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.ReceiveChannel
import kotlinx.coroutines.channels.SendChannel
import kotlinx.coroutines.future.await
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.sqs.SqsAsyncClient
import software.amazon.awssdk.services.sqs.model.Message
import software.amazon.awssdk.services.sqs.model.ReceiveMessageRequest
import kotlin.coroutines.CoroutineContext

//sampleStart

class SqsSampleConsumerChannels(
        private val sqs: SqsAsyncClient
) : CoroutineScope {

    private val supervisorJob = SupervisorJob()
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.IO + supervisorJob

    fun start() = launch {
        val messageChannel = Channel<Message>()
        repeat(N_WORKERS) { launchWorker(messageChannel) }
        launchMsgReceiver(messageChannel)
    }

    fun stop() {
        supervisorJob.cancel()
    }

//sampleEnd

    private fun CoroutineScope.launchMsgReceiver(channel: SendChannel<Message>) = launch {
        runForever {
            val receiveRequest = ReceiveMessageRequest.builder()
                    .queueUrl(SQS_URL)
                    .waitTimeSeconds(20)
                    .maxNumberOfMessages(10)
                    .build()

            val messages = sqs.receiveMessage(receiveRequest).await().messages()
            println("${Thread.currentThread().name} Retrieved ${messages.size} messages")

            messages.forEach {
                channel.send(it)
            }
        }
    }

    private fun CoroutineScope.launchWorker(channel: ReceiveChannel<Message>) = launch {
        runForever {
            for (msg in channel) {
                try {
                    processMsg(msg)
                    deleteMessage(msg)
                } catch (ex: Exception) {
                    println("${Thread.currentThread().name} exception trying to process message ${msg.body()}")
                    ex.printStackTrace()
                    changeVisibility(msg)
                }
            }
        }
    }

    private suspend fun processMsg(message: Message) {
        println("${Thread.currentThread().name} Started processing message: ${message.body()}")
        delay((1000L..2000L).random())
        println("${Thread.currentThread().name} Finished processing of message: ${message.body()}")
    }

    private suspend fun deleteMessage(message: Message) {
        sqs.deleteMessage { req ->
            req.queueUrl(SQS_URL)
            req.receiptHandle(message.receiptHandle())
        }.await()
        println("${Thread.currentThread().name} Message deleted: ${message.body()}")
    }

    private suspend fun changeVisibility(message: Message) {
        sqs.changeMessageVisibility { req ->
            req.queueUrl(SQS_URL)
            req.receiptHandle(message.receiptHandle())
            req.visibilityTimeout(10)
        }.await()
        println("${Thread.currentThread().name} Changed visibility of message: ${message.body()}")
    }
}

fun main() = runBlocking {
    println("${Thread.currentThread().name} Starting program")
    val sqs = SqsAsyncClient.builder()
            .region(Region.US_EAST_1)
            .build()
    val consumer = SqsSampleConsumerChannels(sqs)
    consumer.start()
    delay(30000)
    consumer.stop()
}

private const val N_WORKERS = 4
</xmp>

Our `coroutineContext` has 2 elements: the `Dispatcher` and the `supervisorJob` ([the `+` operation][11] concatenates both elements in a new `CoroutineContext` ).

The _Dispatcher_ marks which thread our coroutine will run on. In our case I used `Dispatchers.IO` that uses a shared pool of threads for doing IO (more details [here][12]). This is because most of the time my coroutines are doing IO operations for: receiving messages, deleting them, changing visibility, etc. If, in your case, processing a message requires a CPU intensive calculation you’d use `Dispatchers.Default` through the `withContext` function like this:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
private suspend fun processMsg(message: Message) = withContext(Dispatchers.Default) {
        // Your code here
    }
</xmp>

## In case of exception

Because we’re responsible developers, let’s see what would happen if something were to fail. 

As a first line of defense we know both our _Workers_ and the _MsgReceiver_ are running in `runForever` loops, so any exception should be logged and ignored. This is ok for us because once the visibility timeout is over, the message will re-appear in the queue for another worker to consume. Still, to be extra careful, let’s consider what would happen with our coroutines in case of exception if we didn’t have `runForever`s.

The whole premise of [structured concurrency][13] is to avoid leaking coroutines in case of failure. That’s why, by default, **whenever a child coroutine terminates with exception its parent and siblings are cancelled too**. This is a nice property, but not quite what we want in this case. We don’t want all workers to be cancelled because one worker threw an exception. That’s why we use `supervisorJob` as part of our `coroutineContext`. [SupervisorJob][14] is like a regular job, with the exception that cancellation is propagated only downwards.

{% img center /images/posts/2019-03-10/Supervisor.png 600 ‘Regular Job vs. Supervisor Job’ %}  

Finally, don’t forget to configure a [dead letter queue][15] for those messages that can’t be processed even after multiple retries.

---- 

That’s all! You can find all the code from this post in [this gist][16]. If you have any improvement to suggest, I’d ❤️ to hear about it. Leave me a comment down there.

{% img right-fill /images/signatures/signature11.png 200 ‘My signature’ %} 

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	Thanks Patrick for the suggestion!

[1]:	https://github.com/aws/aws-sdk-java-v2
[2]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-jdk8/
[3]:	https://kotlinlang.org/docs/reference/coroutines/channels.html
[4]:	https://medium.com/@jayphelps/backpressure-explained-the-flow-of-data-through-software-2350b3e77ce7
[5]:	https://kotlinlang.org/docs/reference/coroutines/channels.html#fan-out
[6]:	https://kotlinlang.org/docs/reference/coroutines/channels.html#channels-are-fair
[7]:	https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-visibility-timeout.html
[8]:	https://kotlinlang.org/docs/reference/coroutines/basics.html#structured-concurrency
[9]:	https://twitter.com/relizarov
[10]:	https://medium.com/@elizarov/structured-concurrency-722d765aa952
[11]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.coroutines.experimental/-coroutine-context/plus.html
[12]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/-dispatchers/-i-o.html
[13]:	https://kotlinlang.org/docs/reference/coroutines/basics.html#structured-concurrency
[14]:	https://kotlinlang.org/docs/reference/coroutines/exception-handling.html#supervision-job
[15]:	https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-dead-letter-queues.html
[16]:	https://gist.github.com/jivimberg/b0f4f94871c6f3e7d17fae1106c28047