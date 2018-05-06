---
layout: post
title: "Parallel map in Kotlin"
date: 2018-05-04 16:32:00 -0700
comments: true
categories: kotlin collections coroutines parallel
---

Ever wonder how to run [`map`][1]  in parallel using coroutines? This is how you do it.

<!--more-->

<xmp class="kotlin-code" data-highlight-only>
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.runBlocking

//sampleStart
fun <A, B>Iterable<A>.pmap(f: suspend (A) -> B): List<B> = runBlocking {
    map { async { f(it) } }.map { it.await() }
}
//sampleEnd
</xmp>

_Confused?_ Let’s unpack it.

First we have the **function signature** which is pretty similar to the actual [`map`][2] extension function signature on `Iterable`. The only thing we added was the `suspend` keyword on the parameter, which let’s us use `suspend` functions in `f` (as we’re going to see in a moment).

Then we have the `runBlocking` which let’s us bridge the blocking code with the coroutine world. As the name suggests **this will block the current thread until everything inside the block finishes executing**. Which is exactly what we want.

Finally we have the actual execution which is divided in 2 steps. The _first step_ **launches a new coroutine for each function application** using [`async`][3]. This effectively wraps the type of each element with  `Deferred`. In the _second step_ we wait for all function applications to complete and unwrap the result with [`await`][4].[^1]

## How to use it

Easy! **Just like you use `map`**:

<xmp class="kotlin-code">
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.runBlocking

fun <A, B>Iterable<A>.pmap(f: suspend (A) -> B): List<B> = runBlocking {
    map { async { f(it) } }.map { it.await() }
}
//sampleStart
fun main(args: Array<String>) {
    println((1..100).pmap { it * 2 })
}
//sampleEnd
</xmp>

(Psst! I’m using [Kotlin Playground][5] so you can actually run this code!)

## Prove that it’s running in parallel

Ok so let’s resort to the good old `delay` to prove that this is actually running in parallel. We are going to add a **delay of 1 second** on each multiplication and measure the time it takes to run. 

Running over _100 elements_ the result should be: **close to 1,000 milliseconds if it’s running in parallel** and close to _100,000 milliseconds if it’s running sequentially_.

<xmp class="kotlin-code">
import kotlinx.coroutines.experimental.async
import kotlinx.coroutines.experimental.runBlocking
import kotlin.system.measureTimeMillis
import kotlinx.coroutines.experimental.delay

fun <A, B>Iterable<A>.pmap(f: suspend (A) -> B): List<B> = runBlocking {
    map { async { f(it) } }.map { it.await() }
}
//sampleStart
fun main(args: Array<String>) {
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

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	Since I’m not explicitly passing any  `CoroutineContext` the `DefaultDispatcher` will be used. 

[1]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/map.html
[2]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/map.html
[3]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.experimental/async.html
[4]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.experimental/-deferred/await.html
[5]:	https://blog.jetbrains.com/kotlin/2018/04/embedding-kotlin-playground/