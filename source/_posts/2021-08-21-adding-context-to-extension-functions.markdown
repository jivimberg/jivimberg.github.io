---
layout: post
title: "Adding Context to Extension Functions"
date: 2021-08-21 20:24:14 -0700
comments: true
categories: kotlin idioms extension-functions
description: Kotlin idiom to limit extension function usage based on context
image: /images/posts/2021-08-21/wrong-suggestion.png
---

Extension functions are great! But if you define them all over the place, it can get confusing pretty quickly. So here’s a cool idiom to limit extension function usage to a specific context.

<!--more-->

Last week I needed to write some code to generate [Atlas Stack Language (ASL)](https://github.com/Netflix/atlas/wiki/Stack-Language) queries. ASL is loosely based on [Reverse Polish Notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation), so you first specify the parameters and then the operation. The query I was trying to generate looked something like this:

 `appName,myapp,:eq,userName,juan,:eq,:and`

I already had methods for the `appName` and `userName` parts and was trying to write the method for the `:and` operator. So I started by writing the tests:

<div class="kotlin-code" data-target-platform="junit" theme="darcula">
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

internal class ASLQueryBuilderTestV1 {

    //sampleStart

    // Tests will fail because `and` hasn't been implemented yet

    @Test
    fun `and should return correct expr if neither param is null`() {
        val expr = and("one", "two")
        assertEquals("one,two,:and", expr)
    }

    @Test
    fun `and should return first param if second param is null`() {
        val expr = and("one", null)
        assertEquals("one", expr)
    }

    @Test
    fun `and should return second param if receiver is null`() {
        val expr = and(null, "two")
        assertEquals("two", expr)
    }

    @Test
    fun `and should return null if both params are null`() {
        val expr = and(null, null)
        assertNull(expr)
    }
    //sampleEnd
}
</div>

Ok, that’s a lie 🙈 I didn’t really start with the tests, as [TDD](https://en.wikipedia.org/wiki/Test-driven_development) suggests. But let’s pretend I did for this example because the test does a good job at explaining the behavior I was going for. Note that the `:and` operator is only applied if both expressions are not _null_.

So here's a straightforward implementation that makes all the tests go ✅:

<div class="kotlin-code" data-target-platform="junit" theme="darcula">
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

internal class ASLQueryBuilderTestV1 {

    @Test
    fun `and should return correct expr if neither param is null`() {
        val expr = and("one", "two")
        assertEquals("one,two,:and", expr)
    }

    @Test
    fun `and should return first param if second param is null`() {
        val expr = and("one", null)
        assertEquals("one", expr)
    }

    @Test
    fun `and should return second param if receiver is null`() {
        val expr = and(null, "two")
        assertEquals("two", expr)
    }

    @Test
    fun `and should return null if both params are null`() {
        val expr = and(null, null)
        assertNull(expr)
    }
}

//sampleStart
fun and(expr1: String?, expr2: String?): String? {
    return when {
        expr1 != null && expr2 != null -> "$expr1,$expr2,:and"
        expr1 != null && expr2 == null -> expr1
        expr1 == null && expr2 != null -> expr2
        else -> null
    }
}
//sampleEnd
</div>

My `and()` method was working, but it was not beautiful. Every time I read it, I had to do some mental gymnastics to understand what was going on 🧠🏋 

Here, judge for yourself:

<div class="kotlin-code" theme="darcula" data-highlight-only>
val expr = and(appNameEquals("myapp"), userNameEquals("juan"))
//      🤔 <- me thinking 
// expr means      (appName == myapp) AND (userName == juan)"
// expr generated  "appName,myapp,:eq,userName,juan,:eq,:and"
</div>

So I had an idea, what if I write it as an [`infix` function](https://kotlinlang.org/docs/functions.html#infix-notation)? Infix functions can only take a single parameter, and I need to receive two expressions, so my only option was to make `and` an extension function. And that’s what I did:

<div class="kotlin-code" data-target-platform="junit" theme="darcula">
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

internal class ASLQueryBuilderTestV1 {

    @Test
    fun `and should return correct expr if neither param is null`() {
        val expr = "one" and "two"
        assertEquals("one,two,:and", expr)
    }

    @Test
    fun `and should return first param if second param is null`() {
        val expr = "one" and null
        assertEquals("one", expr)
    }

    @Test
    fun `and should return second param if receiver is null`() {
        val expr = null and "two"
        assertEquals("two", expr)
    }

    @Test
    fun `and should return null if both params are null`() {
        val expr = null and null
        assertNull(expr)
    }
}

//sampleStart
infix fun String?.and(other: String?): String? {
    return when {
        this != null && other != null -> "$this,$other,:and"
        this != null && other == null -> this
        this == null && other != null -> other
        else -> null
    }
}
//sampleEnd
</div>

Ahh! This reads almost like English. _Me like it very much!_

Except for one thing...

`String?` is a pretty basic type, and `and()` is a pretty common function name. Months from now, somebody will be writing some code and IntelliJ will suggest this:

{% img center /images/posts/2021-08-21/wrong-suggestion.png %}

😱 Watch out unsuspecting coder! That `and` function doesn't do what you think it does!

Leaving this extension function around might be dangerous. So, how can we restrict callers to use it only when writing ASL queries? 

## Extension member functions to the rescue!

The trick is to create a new class named `AslQueryBuilder` and make `and()` a member function of this class. By doing so, we make sure the extension function can only be called from an instance of `AslQueryBuilder`. Nobody will confuse `AslQueryBuilder.and()` with `String.plus()`.

<div class="kotlin-code" theme="darcula" data-highlight-only>
class ASLQueryBuilder {
    infix fun String?.and(other: String?): String? {
        return when {
            this != null && other != null -> "$this,$other,:and"
            this != null && other == null -> this
            this == null && other != null -> other
            else -> null
        }
    }
}
</div>

IntelliJ will no longer suggest `and()` to any random `String?` unless AslQueryBuilder is in scope. Problem solved! 💪

We can use Kotlin's `with()` function to put an instance of `AslQueryBuilder` in scope to call `and()`.

<div class="kotlin-code" data-target-platform="junit" theme="darcula">
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Test

internal class ASLQueryBuilderTestV3 {
    //sampleStart
    private val aslQueryBuilder = ASLQueryBuilder()

    @Test
    fun `and should return correct expr if neither param is null`() {
        val expr = with(aslQueryBuilder) { "one" and "two" }
        expectThat(expr).isEqualTo("one,two,:and")
    }

    @Test
    fun `and should return first param if second param is null`() {
        val expr = with(aslQueryBuilder) { "one" and null }
        expectThat(expr).isEqualTo("one")
    }

    @Test
    fun `and should return second param if receiver is null`() {
        val expr = with(aslQueryBuilder) { null and "two" }
        expectThat(expr).isEqualTo("two")
    }

    @Test
    fun `and should return null if both params are null`() {
        val expr = with(aslQueryBuilder) { null and null }
        expectThat(expr).isNull()
    }
    //sampleEnd
}

infix fun String?.and(other: String?): String? {
    return when {
        this != null && other != null -> "$this,$other,:and"
        this != null && other == null -> this
        this == null && other != null -> other
        else -> null
    }
}
</div>

## Putting it all together

Now that we have an `ASLQueryBuilder` class, let's add the other two required methods in there too:

<div class="kotlin-code" theme="darcula">
class ASLQueryBuilder {

    infix fun String?.and(other: String?): String? {
        return when {
            this != null && other != null -> "$this,$other,:and"
            this != null && other == null -> this
            this == null && other != null -> other
            else -> null
        }
    }

    fun appNameEquals(appName: String?): String? {
        return appName?.let { ":appName,$it,eq" }
    }

    fun userNameEquals(userName: String?): String? {
        return userName?.let { ":userName,$it,eq" }
    }
}

fun main() {
    val aslQueryBuilder = ASLQueryBuilder()
    val finalExpression = with(aslQueryBuilder) {
        appNameEquals("myApp") and userNameEquals("juan")
    }
    print(finalExpression) // :appName,myApp,eq,:userName,juan,eq,:and
}
</div>

And that’s it! The query generation code reads nicely and is easy to understand, and **developers can't call the functions without the explicit `ASLQueryBuilder` context instance, so nobody will use them accidentally**. With this technique we can add any extensions we want to common types without worrying it might pollute the auto-complete and be misused.

---- 

That’s all for today! If you liked this approach, make sure to check [An introduction to context-oriented programming in Kotlin](https://proandroiddev.com/an-introduction-context-oriented-programming-in-kotlin-2e79d316b0a2) and [KEEP-259](https://github.com/Kotlin/KEEP/blob/context-receivers/proposals/context-receivers.md#contextual-functions-and-property-accessors) for what might come in future versions of Kotlin.

{% img right-fill /images/signatures/signature13.png 200 ‘My signature’ %}

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"\>