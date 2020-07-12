---
layout: post
title: "Effective testing - Test structure"
date: 2020-07-10 23:53:38 -0700
comments: true
categories: effective-testing-series testing tests
---

One way to make sure your tests are readable is to have them all adhere to the same structure.

<!--more-->

By far, the most common structure is **"Given - When - Then”** (aka _“Arrange, Act, Assert”_). It goes like this:

1. **On Given**: We create the objects and set up the needed state.
2. **On When**: We perform the action we want to test.
3. **On Then**: We validate the state changed as expected.

For example:

{% img center /images/posts/2020-07-10/exampleJunit.png 700 ‘Example of the proposed structure using JUnit’ %}

The comments explaining each section are optional, and can be omitted on trivial scenarios like the one shown here. 

Note how we use whitespace to clearly separate each section. Anybody familiar with the structure will be able to easily identify each section at a glance. 

{% img center /images/posts/2020-07-10/testSections.jpg 700 ‘Colored sections on test’ %}

Some testing libraries like [Kotest][1] support a style that already includes the _Given_, _When_ and _Then_ keywords, making the structure explicit.

{% img center /images/posts/2020-07-10/exampleKotest.png 700 ‘Example of the proposed structure using Kotest’ %}

---- 

This post is part of the [Effective Testing Series][2].

 {% img right-fill /images/signatures/signature13.png 200 ‘My signature’ %} 

[1]:	https://github.com/kotest/kotest/
[2]:	https://jivimberg.io/blog/categories/effective-testing-series/