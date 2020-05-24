---
layout: post
title: "Parallel map in Kotlin"
date: 2018-05-04 16:32:00 -0700
comments: true
categories: kotlin collections coroutines parallel
---

Ever wonder how to run [`map`][1]  in parallel using coroutines? This is how you do it.

<!--more-->

<xmp class="kotlin-code" data-highlight-only theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.awaitAll

//sampleStart
suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.awaitAll()
}
//sampleEnd
</xmp>

_Confused?_ Let’s unpack it.

First we have the **function signature** which is pretty similar to the actual [`map`][2] extension function signature on `Iterable`. The only thing we added were the `suspend` keywords. One for our function and another one on the parameter.

Then we have the `coroutineScope` that marks the scope in which the `async` calls are going to be executed. This way if something goes wrong and an exception is thrown, all coroutines that were launched in this scope are cancelled. That's the main benefit of [structured concurrency][3]. 

Finally we have the actual execution which is divided in 2 steps: The _first step_ **launches a new coroutine for each function application** using [`async`][4]. This effectively wraps the type of each element with  `Deferred`. 

In the _second step_ we wait for all function invocations to complete and unwrap the result using [`awaitAll()`][5]. This is similar to doing `.map { it.await() }` but better because `awaitAll()` will fail as soon as one of the invocations fails, instead of having to sequentially wait for the call to `await()` on the failing deferred. For example, let’s say we call `pmap` with 3 elements. `f(0)` will complete in 2 minutes, `f(1)` completes in 5 minutes and `f(3)` fails immediately. With `.map { it.await() }` we’d have to wait for `f(1)` and `f(2)` completion before seeing the `f(3)` failure, whereas [`awaitAll()`][6] will know that something failed right away.

## How to use it

Easy! **Just like you use `map`**:

<xmp class="kotlin-code" theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.Dispatchers

suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.awaitAll()
}
//sampleStart
fun main(args: Array<String>) = runBlocking(Dispatchers.Default) {
	println((1..100).pmap { it * 2 })
}
//sampleEnd
</xmp>

(Psst! I’m using [Kotlin Playground][7] so you can actually run this code!)

## Prove that it’s running in parallel

Ok so let’s resort to the good old `delay` to prove that this is actually running in parallel. We are going to add a **delay of 1 second** on each multiplication and measure the time it takes to run. 

Running over _100 elements_ the result should be: **close to 1,000 milliseconds if it’s running in parallel** and close to _100,000 milliseconds if it’s running sequentially_.

<xmp class="kotlin-code" theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlin.system.measureTimeMillis
import kotlinx.coroutines.delay
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.Dispatchers

suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.awaitAll()
}
//sampleStart
fun main(args: Array<String>) = runBlocking(Dispatchers.Default) {
	val time = measureTimeMillis {
	    val output = (1..100).pmap {
	        delay(1000)
	        it * 2
	    }
	
	    println(output)
	}
	
	println("Total time: $time")
}
//sampleEnd
</xmp>


## Beware of `runBlocking`

A previous iteration of this article proposed the following solution:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.awaitAll

//sampleStart
// DON'T DO THIS
fun <A, B> Iterable<A>.pmapOld(f: suspend (A) -> B): List<B> = runBlocking {
	map { async { f(it) } }.awaitAll()
}
//sampleEnd
</xmp>

As [Gildor][8] pointed out in the comments, [this a very bad idea][9]. By default [`runBlocking` uses a dispatcher that is confined to the invoker thread][10]. Which means we are forcefully blocking the thread until the execution of `pmap` finishes, instead of letting the caller decide how the execution should go. 

Note that the same would happen if we simply wrap our `pmap` call with `runBlocking`. 

<xmp class="kotlin-code" data-highlight-only theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.awaitAll


suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.awaitAll()
}

//sampleStart
// DON'T DO THIS
fun main() = runBlocking<Unit> {
	(1..100).pmap { fibonnaci(it.toBigInteger()) }
}
//sampleEnd

</xmp>

This is because `coroutineScope` basically inherits the caller’s context. So again we’d be running in the single thread confined Dispatcher `runBlocking` gets by default. Which may, or may not, be OK depending on your use case. Remember that you can always change the Dispatcher used by `runBlocking` by passing one: `runBlocking(Dispatchers.IO)`.

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[1]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/map.html
[2]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/map.html
[3]:	https://kotlinlang.org/docs/reference/coroutines/composing-suspending-functions.html#structured-concurrency-with-async
[4]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.experimental/async.html
[5]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/await-all.html
[6]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines/await-all.html
[7]:	https://blog.jetbrains.com/kotlin/2018/04/embedding-kotlin-playground/
[8]:	https://disqus.com/by/disqus_VE5B5eZQX9/
[9]:	http://disq.us/p/1zbc6a7
[10]:	https://kotlinlang.org/docs/reference/coroutines/coroutine-context-and-dispatchers.html#unconfined-vs-confined-dispatcher