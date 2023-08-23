---
layout: post
title: Mockk all the things
date: 2019-05-09 07:57:47 -0700
comments: true
categories: mockk test kotlin stub spy mocking
---

Over the last few years Mockk has been gaining ground as the go-to mocking library in KotlinWorld ™. Just recently, it was listed as _“adopt”_ in the [ThoughtWorks technology Radar][1]. Want to know what all the fuss is about? 

<!--more-->

{% img center /images/posts/2019-05-18/mockkAllTheThings.gif ‘Channels animation’ %}

## Regular mocking

Let’s start with the basics. You can _mock_, _spy_ and _verify_ using this [cute little DSL][2] 

<xmp class="kotlin-code" data-highlight-only theme="darcula">
import io.mockk.every
import io.mockk.mockk
import io.mockk.spyk
import io.mockk.verify
import org.junit.jupiter.api.Test

class ClockTest {

//sampleStart
	@Test
	fun `regular mock`() {
	    val clock = mockk<Clock>()
	    every { clock.currentTime() } returns "7:20"
	
	    clock.currentTime()
	
	    verify { clock.currentTime() }
	}
	
	@Test
	fun `regular spy`() {
	    val clock = spyk<Clock>()
	
	    clock.currentTime()
	
	    verify { clock.currentTime() }
	}
	//sampleEnd
}
</xmp>

## Mocks with behavior

No need to settle for just one fixed return value. You can add complex behavior to your mocks like this:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mock with complex behavior`() {
	    val clock = mockk<Clock>()
	    every { clock.currentTime() } answers { dateFormat.format(Calendar.getInstance()) }
	
	    // ...
	}
	
	companion object {
	    val dateFormat = SimpleDateFormat("HH:mm")
	}
	//sampleEnd
}
</xmp>

There are a bunch of utility functions and properties you can use inside the `answers` lambda to do things like calculate the response based on the function arguments. Full list [here][3].

## Mock chained calls

You can easily mock a chain of calls

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mocking chained calls`() {
	    val oven = mockk<Oven>()
	    every { oven.clock.currentTime() } returns "7:20"
	
	    //...
	}
	//sampleEnd
}
</xmp>

## Mock hierarchies

You can achieve the same result using hierarchical mocking

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `hierarchical mocking`() {
	    val oven = mockk<Oven>()
	    every { oven.clock } returns mockk {
	        every { currentTime() } returns "7:20"
	    }
	
	    //...
	}
	//sampleEnd
}
</xmp>

This is especially useful when mocking complex structures and to return collections of mocking objects, like in [this example][4].

## Mock objects

You can mock Objects as easily as you mock regular classes

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `object mocking`() {
	    mockkObject(UrlHelper)
	    every { UrlHelper.getBaseUrl() } returns URL("http://mockUrl.com")
	
	    //...
	}
	//sampleEnd
}
</xmp>

## Mock Unit

You can mock functions that return `Unit` using `just Runs`

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mocking functions that return Unit`() {
	    val clock = mockk<Clock>()
	    every { clock.changeBatteries() } just Runs
	
	    //...
	}
	//sampleEnd
}
</xmp>

## Mock Nothing

Or functions that return Nothing. In which case you have to throw an exception as behavior (because a function that returns `Nothing` [never returns][5] and can only end by throwing an exception, remember?) 

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mocking functions that return Nothing`() {
	    val clock = mockk<Clock>()
	    every { clock.runForever() } throws Exception("called runForever")
	
	    //...
	}
	//sampleEnd
}
</xmp>

## Mock extensions functions

You can mock extensions functions as well:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mocking functions extension functions`() {
	    with(mockk<Clock>()) {
	        every { Duration.ofMinutes(5).startTimer() } returns true
	
	        //...
	    }
	}
	//sampleEnd
}
</xmp>

This works If the extension functions is defined on a class or an object. If it’s defined as a top level function instead, you can still mock it by following the advise in the next point 👇

## Mocking top level functions

Got a top level function to mock? We’ve got you covered.

<xmp class="kotlin-code" data-highlight-only theme="darcula">
   class ClockTest {
   //sampleStart
	@Test
	fun `mocking top level functions`() {
	    mockkStatic("mockk.ModelsKt")
	    every { resolve(any()) } returns URL("http://mockk.com/users/1")
	
	    //...
	}
	//sampleEnd
}
</xmp>

Ok, you might need to check your classes to know exactly what to use as argument for `mockkStatic`, but it’s no big deal.

## Mock private functions

Yep, you can mock private functions by name.

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mocking private functions`() {
		val oven = mockk<Oven>()
		every { oven["lockDoor"]() } returns true
		
		//...
	}
	//sampleEnd
}
</xmp>

You can even verify calls to private function by using `recordPrivateCalls = true`

## Mock varargs

There’s also support for mocking functions that use varargs:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class VarargsTest {
	//sampleStart
	interface Calculator {
		fun sumEverything(vararg num: Int): Int
	}

	@Test
	fun `mocking varargs`() {
		val calculator = mockk<Calculator>()
		every { calculator.sumEverything(1, 2, 4) } returns 7

		//...

		every { calculator.sumEverything(1, *anyIntVararg(), 4) } returns 12

		//...

		every { calculator.sumEverything(1, *varargAllInt { it < 5 }) } returns 10

		//...
	}
	//sampleEnd
}
</xmp>

And it’s not only the basics either. As you can see in the example you can do all kind of complex matchings.

## Mock constructor

You can mock constructors. Useful for those times when you don’t actually control the object creation, but want to still be able to mock it.

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
	//sampleStart
	@Test
	fun `mocking constructor`() {
		mockkConstructor(Clock::class)

		every { anyConstructed<Clock>().currentTime() } returns "7:40"

		assertEquals("7:40", Clock().currentTime())
	}
	//sampleEnd
}
</xmp>

## Mock coroutines

If you’re working with coroutines and want to mock a suspending function you simply use `coEvery`. In this example `startTimer` is a suspending function:

<xmp class="kotlin-code" data-highlight-only theme="darcula">
class ClockTest {
    //sampleStart
    @Test
    fun `mocking suspending functions`() {
        val clock = mockk<Clock>()
        coEvery { clock.startTimer() } returns RUNNING

        // ...
    }
    //sampleEnd
}
</xmp>

Along with `coEvery` there’s a whole family of `co...` functions (`coAnswers`, `coVerify`, `coAssert`, etc.) for working with coroutines.

---- 

This is by no means a comprehensive guide. My intention was just to showcase same of the things that Mockk can do for you. For an in-depth introduction I recommend checking the [_“Mocking is not rocket science”_ series in Kotlin Academy][6].

 {% img right-fill /images/signatures/signature10.png 200 ‘My signature’ %} 

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[1]:	https://www.thoughtworks.com/radar/languages-and-frameworks/mockk
[2]:	https://mockk.io/#dsl-tables
[3]:	http://mockk.io/#answer-scope
[4]:	https://mockk.io/#hierarchical-mocking
[5]:	https://kotlinlang.org/api/latest/jvm/stdlib/kotlin/-nothing.html
[6]:	https://blog.kotlin-academy.com/search?q=mockk