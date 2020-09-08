---
layout: post
title: "Effective Testing - Show what's important, hide the rest"
date: 2020-09-07 18:05:00 -0700
comments: true
categories: effective-testing-series testing tests builder
---

What we include in a test is as important as what we leave out. Having the right amount of information helps us understand what the test is doing at a glance.

<!--more-->

Let's say we need to check our Restaurants are behaving correctly. We want to validate two things:

1. That a restaurants can only cook a `Recipe` if they have all the necessary ingredients.
2.  That vegan restaurants do not serve non-vegan food

{% img center /images/posts/2020-09-07/restaurantTestsBefore.png 700 ‘Repetitive tests’ %}

This works fine, but writing a new `Recipe` for every single test gets repetitive pretty fast. More importantly, most lines of the test are spent creating the `Recipe` object. By having to spell out every single property, we lose track of what’s important for each specific test.

Luckily, we can use [Kotlin default arguments][1] to make the tests better. We could introduce default values directly on the `Recipe` class, but that would mean we’d have to pick sensible defaults for Recipes in production. We probably don’t want to allow for this flexibility, as we want to force users to specify those properties for each recipe defined. Instead, we will write a [_helper function_][2] with default arguments to handle the `Recipe` creation. We’ll make it `private` so that it’s only accessible in the test class.

{% img center /images/posts/2020-09-07/helperFunction.png 700 ‘Helper function’ %}

Now we can re-write our tests to make use of the helper function:

{% img center /images/posts/2020-09-07/restaurantTestsAfter.png 700 ‘Improved tests’ %}

On each test, we only specify the property that the test cares about and leave out all the other ones. This way, somebody glancing at the test can immediately identify what we’re checking, and it’s not distracted by the details on how to create a `Recipe` object.

Note that this is a simplified example. In real life, the object being created could have multiple nested objects and require many steps to be initialized. All that code would be hidden in our helper function instead of bloating every test.

We could have written the test for vegan recipes without specifying any property, and it would still pass.

{% img center /images/posts/2020-09-07/notExplicit.png 700 ‘Not explicit enough tests’ %}

By default `isVegan` is true, so we're not required to define it. However, **we opted for explicitly specifying it in the test**, just so that somebody reading the test would know that the value of `isVegan`  is important for this test. As an extra benefit, the test will not break if, in the future, somebody decides to change the default value for `isVegan`.

---- 

This post is part of the [Effective Testing Series][3].

 {% img right-fill /images/signatures/signature10.png 200 ‘My signature’ %} 

[1]:	https://kotlinlang.org/docs/reference/functions.html#default-arguments
[2]:	https://phauer.com/2018/best-practices-unit-testing-kotlin/#use-helper-functions-with-default-arguments-to-ease-object-creation
[3]:	https://jivimberg.io/blog/categories/effective-testing-series/