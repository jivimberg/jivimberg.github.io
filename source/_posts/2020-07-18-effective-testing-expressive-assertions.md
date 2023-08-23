---
layout: post
title: "Effective Testing - Expressive Assertions"
date: 2020-07-18 11:58:34 -0700
comments: true
categories: effective-testing-series testing tests assertions
---

Using expressive assertions can help us figure out why a test fails without having to go through the code.

<!--more-->

Let's start with an example. Here's a test making sure our recipe has tomatoes 🍅

{% img center /images/posts/2020-07-19/badAssertion.png 700 ‘A test with a non-descriptive assertion’ %}

At first glance, everything looks ok. The test passes, it is easy to read, and it follows [the _”Given - When - Then”_  structure][1].  

Some months go by, and one day our test starts failing.

{% img center /images/posts/2020-07-19/badAssertionOutput.png 700 ‘The output of a test with a non-descriptive assertion’ %}

At this point, we've probably forgotten everything about the recipe, and we’re not sure what’s causing the failure. [The test name is not helping us much either][2].

To avoid this situation, we can include a message that will be displayed whenever the assertion fails.

{% img center /images/posts/2020-07-19/withMessage.png 700 ‘Assertion with explicit message’ %}

{% img center /images/posts/2020-07-19/withMessageOutput.png 700 ‘Output of a test with an assertion with explicit message’ %}

Now the failure is obvious. There is no 🍅 on the recipe. **We can immediately tell what’s wrong without even looking at the test code.** But we can do better…

## Assertion libraries

Let's face it, writing this kind of detailed message for every assertion would be a pain in the ass. Fortunately, we don’t have to. Instead, **we can use an [expressive assertion library][3] to do the heavy lifting for us.** This is how our code would look like using [Strikt][4]:

{% img center /images/posts/2020-07-19/strikt.png 700 ‘Example using Strikt’ %}

We're using [Kotlin infix notation][5] to make the code more readable. This a stylistic decision, you don’t have to use it if you don’t like it. 

You might notice we're calling the `contains` method on the assertion itself. This is possible because Strikt can tell that the type we’re asserting on, is a _String_, and thus, it can provide methods explicitly tailored to Strings. This is what the error message would look like in this case:

{% img center /images/posts/2020-07-19/outputStrikt.png 700 ‘Output of the basic Strikt example’ %}

**Almost the same information we got from writing our own message, but without the boilerplate.**

Assertion libraries are like swiss army knives; they provide all kinds of assertions for different types of objects. I suggest learning a few of the core ones through the documentation, and then letting the IDE guide you with auto-suggestions to discover new ones.

Here are some more examples of type-specific assertions:

{% img center /images/posts/2020-07-19/collectionAssertion.png 700 ‘Collection specific assertions’ %}

{% img center /images/posts/2020-07-19/assertingExceptions.png 700 ‘Asserting exceptions’ %}

## Asserting on objects

When validating properties on objects, you might be tempted to write something like this:

{% img center /images/posts/2020-07-19/badObjectAssertions.png 700 ‘Manually asserting properties on object’ %}

You can probably tell why this is bad. By the time we see the failure, we no longer have context on what property we’re asserting. 

{% img center /images/posts/2020-07-19/objectAssertionOutput.png 700 ‘Using data classes for assertions’ %}

Was it checking the `title`, the `author`, or something else?

Instead, you can take advantage of the fact that Data Classes automatically get `equals` and `toString` implementations. So we can use an `assertEquals` and get a nice looking message showing us both instances.

{% img center /images/posts/2020-07-19/dataClasses.png 700 ‘Using data classes for assertions’ %}

{% img center /images/posts/2020-07-19/dataClassesOutput.png 700 ‘Using data classes test output’ %}

If we don't care about comparing all properties we can use [Strikt to assert only specific fields][6]:

{% img center /images/posts/2020-07-19/traversingObjects.png 700 ‘Using Strikt to traverse objects on assertions’ %}

{% img center /images/posts/2020-07-19/traversingObjectsOutput.png 700 ‘Strikt object traversal test output’ %}
 
The [block assertion style][7] means that even though the _title_ assertion failed Strikt will still check for _page count_ and **it’ll provide output for all the assertions in the block.**

---- 

This post is part of the [Effective Testing Series][8].

 {% img right-fill /images/signatures/signature2.png 200 ‘My signature’ %} 

[1]:	https://jivimberg.io/blog/2020/07/10/effective-testing-test-structure/
[2]:	https://jivimberg.io/blog/2020/07/05/effective-testing-use-descriptive-test-names/
[3]:	https://blog.frankel.ch/comparison-assertion-libraries/
[4]:	https://strikt.io/
[5]:	https://kotlinlang.org/docs/reference/functions.html#infix-notation
[6]:	https://strikt.io/wiki/traversing-subjects/
[7]:	https://strikt.io/wiki/assertion-styles/
[8]:	https://jivimberg.io/blog/categories/effective-testing-series/