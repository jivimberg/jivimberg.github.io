---
layout: post
title: "Go channels in Kotlin - An example"
date: 2018-04-23 08:37:13 -0700
comments: true
categories: kotlin coroutines go channels
---

This is the story of a real use case that was solved by using [Go style channels in Kotlin][1].

<!--more-->

## The use case
At work we have this CI/CD pipeline to get our code into production, and we needed a way of visualizing the Merge Requests that currently in the pipeline.

To make this happen we have 2 things:

* The GitLab service, accessible through [REST][2]
* The commit SHA of the last Merge Request that went into production

{% img center /images/posts/2018-04-24/useCase.png ‘Use Case’ %} 

Now the problem is that [Merge Request endpoint][3] doesn’t allow for this kind of query. You can only search Merge Requests by _title_ or _description_ which is not what we want. So our only option is to get the latest Merge Requests up until we see the one that is in production. 

The REST endpoint is paginated, and by default each response will contain 20 items. But what happens if the Merge Request we are looking for is not in those first 20 elements? **We’ll need to keep making requests for new pages until we find the item we’re interested in**. It’s not the most elegant solution but we’ll have to make do with what we have.

## Our first approach: imperative
Our first try of putting that last paragraph into code looked something like this:

{% gist 862c4ee1c72603a224d57b30eedf74fc ImperativeApproach.kt %}

Not pretty, but it does the job.

The next attempt we made was implementing it as an `Iterable`. And it was even uglier! Believe me, you don’t even want to see that one. Your retina might burn just from looking at the [code…][4]

## Using _buildSequence_
We kept looking for a way of making the code cleaner, so we decide to try using [`buildSequence`][5]. It seemed like a good idea because a sequence can be thought as an `Iterator` where the values are evaluated lazily. So potentially `Sequences` can be infinite. 

To make use of this feature we needed to add the [kotlinx-coroutines-core][6]
 to our project. Anyway, this is how the code looked like:

{% gist 862c4ee1c72603a224d57b30eedf74fc SequenceApproach.kt %}

Let’s unpack it:

1. First we have the sequence declaration. We call the build sequence function which receives a _lambda with receiver_: `SequenceBuilder<T>.() -> Unit`. This allows us to call the methods `yield` and `yieldAll` once we have calculated the values to be produced on this sequence. We use `yieldAll` in this case because we receive a Collection of values from the REST call, otherwise the type of the sequence would be: `Sequence<List<MergeReques>>` whereas we only need `Sequence<MergeRequest>`
2. We use `takeWhile { ... }` to only get the Merge Requests that are **not** in production.
3. We convert the sequence to a List and return

You might be thinking **”Ok but, why is this better than the imperative approach?”**

For starters this code is easier to read. This alone is reason enough in my book, as the quote goes: 

> _”Any fool can write code that a computer can understand. **Good programmers write code that humans can understand.**”_
> 
> Martin Fowler 

As a bonus by using a `Sequence` we get some extra flexibility. In the imperative approach the condition is right in the middle of the function. Using sequences we could easily have a function that generates the sequence and then write other functions that use it, leveraging all the awesome collection functions (`filter`, `find`, `take`, `drop`, etc). 

It is important to note that when using sequences the evaluation is lazy (just like Java streams). In our case that means that `takeWhile` will only start once we call the `toList` function, because `toList` is a _terminal_ operation.

So are we using coroutines now? **YES!** But… `buildSequence` is coroutine builder that creates a _synchronous coroutine_. This means that even thought it uses coroutines everything is executed sequentially.

## Using channels
Finally we decided to go all in on coroutines by using channels. This is the result: 

{% gist 862c4ee1c72603a224d57b30eedf74fc ChannelApproach.kt %}

Now we have a function that creates a channel, and we are using `consumeEach`  to receive each of the elements the channel sends. Since `consumeEach` is a suspending function **we have to call it from a coroutine context**, `runBlocking` helps us bridge the gap between blocking execution and the coroutines world.

With `ReceiveChannel` we have the flexibility of `Sequences`, but we also get one more thing: **concurrency!**. You can see that I’ve added an artificial `delay` call before beginning to consume the Merge Requests. This is to show that **even before the receiver is ready to consume the channel, the producer has already started to fetch elements**. In this case since we’re using an [_unbuffered channel_][7] only one send will be called before suspending the coroutine. But that’s all we need since in our case sending 1 element means that we’ve already fetched the whole first page!

[1]:	https://github.com/Kotlin/kotlinx.coroutines/blob/master/coroutines-guide.md#channels
[2]:	https://docs.gitlab.com/ee/api
[3]:	https://docs.gitlab.com/ee/api/merge_requests.html
[4]:	https://gist.github.com/jivimberg/862c4ee1c72603a224d57b30eedf74fc#file-iterableapproach-kt
[5]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.coroutines.experimental/build-sequence.html
[6]:	https://mvnrepository.com/artifact/org.jetbrains.kotlinx/kotlinx-coroutines-core
[7]:	https://github.com/Kotlin/kotlinx.coroutines/blob/master/coroutines-guide.md#buffered-channels