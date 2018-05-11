---
layout: post
title: "Parallel Map in Java (from Kotlin)"
date: 2018-05-07 13:19:58 -0700
comments: true
categories: java collections kotlin parallel
---

Following up of my [previous post][1], I was curious how a parallel map operation would look like using Java’s [`parallelStream`][2]. Here’s what I find out.

<!--more-->

In Java to use `map` you do:

<xmp class="kotlin-code">
import java.util.stream.Collectors

//sampleStart
fun main(args: Array<String>) {
    val output = (1..100).toList()
            .stream()
            .map { it * 2 }
            .collect(Collectors.toList())
    println(output)
}
//sampleEnd
</xmp>

_(In case you’re wondering I’m using Java collections from Kotlin)_

And to do a _parallel_ `map` you can simply do:

<xmp class="kotlin-code">
import java.util.stream.Collectors

//sampleStart
fun main(args: Array<String>) {
    val output = (1..100).toList()
            .parallelStream()
            .map { it * 2 }
            .collect(Collectors.toList())
    println(output)
}
//sampleEnd
</xmp>

No need to write a special `pmap` operation like we did for Kotlin. Just call `parallelStream` and that’s it. _Pretty cool, right?_

I was curious about how this solution **compared to the one on [my previous post][3]**,  so I decided to time it too. 

<xmp class="kotlin-code">
import java.util.stream.Collectors
import kotlin.system.measureTimeMillis

//sampleStart
fun main(args: Array<String>) {
    val time = measureTimeMillis {
        val output = (1..100).toList()
                .parallelStream()
                .map {
                    Thread.sleep(100)
                    it * 2
                }
                .collect(Collectors.toList())

        println(output)
    }

    println("Total time: $time")
}
//sampleEnd
</xmp>

In this case instead I’m actually setting a delay of **100 milliseconds** (instead of _1,000_ like I did on my previous post)[^1]. I was expecting the total time to be something close to _100 milliseconds_, just like it was for the Kotlin `pmap`, **instead I got something close to 5,000**. 

Turns out `parallelStream` uses the default [_ForkJoinPool.commonPool_][4] which by default has a parallelism level **equal to the number of available processors.** In this case 2 processors: _100 operations \* 100 milliseconds / 2 processors = 5000 milliseconds_. You can check the number of available processors simply by adding this line to the script: 

`println(Runtime.getRuntime().availableProcessors())`

## But, I want more parallelism!

What if we want to increase the parallelism level? There are _2 ways to achieve this._

_The first one_ is to make our code **run in a custom thread pool** of our choice. Unfortunately Java doesn’t make it easy to provide a custom thread pool, but [the workaround is not so bad either][5].

_The other option_ is to change the [_ForkJoinPool.commonPool_][6] parallelism level by system property like this: 

`System.setProperty("java.util.concurrent.ForkJoinPool.common.parallelism", "10")` 

Unfortunately this doesn’t work on Kotlin Playground so you’ll have to try it on your own machine or take my word that it works.

It’s worth noting that with the second approach you’d still be using the same default thread pool **shared globally across the app**. As you can imagine this can be **EXTREMELY BAD** as you’d be basically depleting resources for the whole application. Some would even argue [this is reason enough not to use `parallelStream` at all][7]. Although that seems a little extreme if you ask me.

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	Otherwise the execution takes too long and doesn’t complete. Probably a limitation of Kotlin Playground

[1]:	http://jivimberg.io/blog/2018/05/04/parallel-map-in-kotlin/
[2]:	https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#parallelStream--
[3]:	http://jivimberg.io/blog/2018/05/04/parallel-map-in-kotlin/
[4]:	https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ForkJoinPool.html
[5]:	http://www.baeldung.com/java-8-parallel-streams-custom-threadpool
[6]:	https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ForkJoinPool.html
[7]:	https://zeroturnaround.com/rebellabs/java-parallel-streams-are-bad-for-your-health/