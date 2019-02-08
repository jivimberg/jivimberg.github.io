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

//sampleStart
suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.map { it.await() }
}
//sampleEnd
</xmp>

_Confused?_ Let’s unpack it.

First we have the **function signature** which is pretty similar to the actual [`map`][2] extension function signature on `Iterable`. The only thing we added were the `suspend` keywords. One for our function and another one on the parameter.

Then we have the `coroutineScope` that marks the scope in which the `async` calls are going to be executed. This way if something goes wrong and an exception is thrown, all coroutines that were launched in this scope are cancelled. That's the main benefit of [structured concurrency][3]. 

Finally we have the actual execution which is divided in 2 steps: The _first step_ **launches a new coroutine for each function application** using [`async`][4]. This effectively wraps the type of each element with  `Deferred`. In the _second step_ we wait for all function applications to complete and unwrap the result with [`await`][5].[^1]

## How to use it

Easy! **Just like you use `map`**:

<xmp class="kotlin-code" theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.runBlocking

suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.map { it.await() }
}
//sampleStart
fun main(args: Array<String>) = runBlocking {
	println((1..100).pmap { it * 2 })
}
//sampleEnd
</xmp>

(Psst! I’m using [Kotlin Playground][6] so you can actually run this code!)

## Prove that it’s running in parallel

Ok so let’s resort to the good old `delay` to prove that this is actually running in parallel. We are going to add a **delay of 1 second** on each multiplication and measure the time it takes to run. 

Running over _100 elements_ the result should be: **close to 1,000 milliseconds if it’s running in parallel** and close to _100,000 milliseconds if it’s running sequentially_.

<xmp class="kotlin-code" theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import kotlin.system.measureTimeMillis
import kotlinx.coroutines.delay
import kotlinx.coroutines.coroutineScope

suspend fun <A, B> Iterable<A>.pmap(f: suspend (A) -> B): List<B> = coroutineScope {
	map { async { f(it) } }.map { it.await() }
}
//sampleStart
fun main(args: Array<String>) = runBlocking {
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


## Why not `runBlocking`?

A previous iteration of this article proposed the following solution:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking

//sampleStart
fun <A, B> Iterable<A>.pmapOld(f: suspend (A) -> B): List<B> = runBlocking {
    map { async { f(it) } }.map { it.await() }
}
//sampleEnd
</xmp>

And the description said:

> Then we have the `runBlocking` which lets us bridge the blocking code with the coroutine world. As the name suggests **this will block the current thread until everything inside the block finishes executing**. Which is exactly what we want.

Fortunately [Gildor][7] commented on why [this a bad idea][8]. First, we were not using [Structured Concurrency][9], so an invocation of `f` could fail and all other executions would continue unfazed. And also we were not playing nice with the rest of the code. By using `runBlocking` we were forcefully blocking the thread until the whole execution of `pmap` finishes, instead of letting the caller decide how the execution should go.

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	Since I’m not explicitly passing any  `CoroutineContext` the `DefaultDispatcher` will be used. 

[1]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/map.html
[2]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/map.html
[3]:	https://kotlinlang.org/docs/reference/coroutines/composing-suspending-functions.html#structured-concurrency-with-async
[4]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.experimental/async.html
[5]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.experimental/-deferred/await.html
[6]:	https://blog.jetbrains.com/kotlin/2018/04/embedding-kotlin-playground/
[7]:	https://disqus.com/by/disqus_VE5B5eZQX9/
[8]:	http://disq.us/p/1zbc6a7
[9]:	https://medium.com/@elizarov/structured-concurrency-722d765aa952