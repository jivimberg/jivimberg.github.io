---
layout: post
title: "Implementing takeWhileInclusive in Kotlin"
date: 2018-06-02 13:33:38 -0700
comments: true
categories: kotlin takeWhile collections extensions
---

Implementing `takeWhileInclusive` extension function in Kotlin.

<!--more-->

> TL,DR (aka _“just show me the code”_ ): https://gist.github.com/jivimberg/ff5aad3f5c6315deb420fd508a145c61

You probably know about [`takeWhile`][1] operation that **returns a List containing the first elements satisfying the given predicate.**

<xmp class="kotlin-code">
fun main(args: Array<String>) {
//sampleStart
	val someNumbers = listOf(1, 5, 3, 22, 4, 8, 14, 23, 49, 77, 2, 49)
	println(someNumbers.takeWhile { it % 7 != 0 })
//sampleEnd
}
</xmp>

I was in need of an **inclusive** version of the `takeWhile`. In other words I needed a function that returned the first elements satisfying the given predicate, **plus the first element that didn’t satisfy it**. 

So in the provided example `takeWhile` returns `[1, 5, 3, 22, 4, 8]` whereas `takeWhileInclusive` would return `[1, 5, 3, 22, 4, 8, 14] ` .

A quick search showed me I was not alone. [_matklad_][2] already had a simple implementation working for `Sequence`:

{% gist 54776705250e3b375618f59a8247a237 %}

Using **extension functions** we are able to add a new function to the standard library type `Sequence`. If this is your first encounter with an extension function I’d encourage you to read more about them [here][3] and then play with them [here][4].

I found this implementation of `takeWhileInclusive` quite **elegant**. It uses the original `takeWhile` with the given predicated, but keeps a `shouldContinue` variable to delay the predicate evaluation by one step. In other words the evaluation of the predicate passed to `takeWhile` on element _i_ will actually be the result of applying the predicate function on _i - 1_. Which if you think about it _is exactly what we need_. Let’s give it a try:

<xmp class="kotlin-code">
fun <T> Sequence<T>.takeWhileInclusive(
	    predicate: (T) -> Boolean
): Sequence<T> {
	var shouldContinue = true
	return takeWhile {
	    val result = shouldContinue
	    shouldContinue = predicate(it)
	    result
	}
}

fun main(args: Array<String>) {
//sampleStart
   val someNumbers = listOf(1, 5, 3, 22, 4, 8, 14, 23, 49, 77, 2, 49).asSequence()
   println(someNumbers.takeWhileInclusive { it % 7 != 0 }.toList())
//sampleEnd
}
</xmp>

This was good! Only [this comment][5] posted on the original gist made me doubt about the _safety_ of this approach:

> _“I love this. If Sequence were parallel, though, wouldn't there be worries about using out-of-closure state?”_

That send me down the rabbit hole and I spent some days reading about `parallelStreams` and `coroutines` until I convinced my self the approach was ok.[^1] 

With that out of the way I decided to port this solution to be supported in all the places where the `takeWhile` exists (including `String` and `CharArray`). So that **we don’t have to convert to a from a Sequence just to use this function**.

Here’s the end result, ready to be dropped on your project:

{% gist ff5aad3f5c6315deb420fd508a145c61 %}

Hope you find this useful!

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	If you want to read more about my discoveries, check this question at [StackOverflow](https://stackoverflow.com/q/50373754/1499171)

[1]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/take-while.html
[2]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin.collections/take-while.html
[3]:	https://kotlinlang.org/docs/reference/extensions.html#extension-functions
[4]:	https://try.kotlinlang.org/#/Kotlin%20Koans/Introduction/Extension%20functions/Task.kt
[5]:	https://gist.github.com/matklad/54776705250e3b375618f59a8247a237#gistcomment-2093675