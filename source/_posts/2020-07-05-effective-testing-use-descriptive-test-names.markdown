---
layout: post
title: "Effective Testing - Use descriptive test names"
date: 2020-07-05 23:21:07 -0700
comments: true
categories: effective-testing-series testing tests
---

Picking good test names can help us identify what's wrong with our code when something fails.

<!--more-->

It's Friday afternoon. You finally finished that long refactor you’ve been working on for the whole week. Everything is looking good. Except you run the tests and see one failure.

{% img center /images/posts/2020-07-05/BadNames.png ‘Test output with bad test names’ %}

<p style='text-align: center; font-size: 42px;'>
🤔
</p>

Unfortunately, **you can't really tell what's broken from looking at that output**. You’ll have to browse the test code to identify the failure. 

But what if the output looked more like this:

{% img center /images/posts/2020-07-05/GoodNames.png ‘Test output with good test names’ %}

Now the issue is obvious. **You can immediately tell which part of the code is not working and what the output should be.**

Test names are the first (and often only) piece of information we see about a test. Using a descriptive test name can help us identify what’s broken at a glance. Furthermore, it helps us keep the test focused on validating one specific behavior, discouraging us from inflating the test with other unrelated assertions. 

## How

Instead of just using the name of the method being tested, try focusing on the behavior you want to validate. **Describe the state of the system, the action performed, and the expected output.** More often than not, you’ll end up with a huge name, something you probably wouldn’t use on production code, but that’s ok.

If you're using Kotlin, you can [use backticks to have whitespaces in your function name][1]. If you’re working with [JUnit][2] you can leverage the [`@DisplayName`][3] annotation for prettier names. You can even get emojis in there:

{% img center /images/posts/2020-07-05/WithEmojis.png ‘Test output with emojis’ %}

You can also write a custom name generator using `@DisplayNameGeneration` [as shown here][4]. 

Some testing libraries like [Kotest][5], also [support nesting tests][6]: 

{% img center /images/posts/2020-07-05/NestedNames.png ‘Test output with emojis’ %}

---- 

You can read more about test naming in Chapter 12 of [Software Engineering at Google][7].

This post is part of the [Effective Testing Series][8].

 {% img right-fill /images/signatures/signature14.png 200 ‘My signature’ %} 

[1]:	https://kotlinlang.org/docs/reference/coding-conventions.html#function-names
[2]:	https://junit.org/junit5/docs/current/user-guide/
[3]:	https://junit.org/junit5/docs/5.0.3/api/org/junit/jupiter/api/DisplayName.html
[4]:	https://www.baeldung.com/junit-custom-display-name-generator
[5]:	https://github.com/kotest/kotest/
[6]:	https://github.com/kotest/kotest/blob/master/doc/styles.md#should-spec
[7]:	https://www.amazon.com/Software-Engineering-Google-Lessons-Programming/dp/1492082791/ref=sr_1_2?dchild=1&keywords=software+engineering+at+google&link_code=qs&qid=1594020903&sr=8-2&tag=wwwcanoniccom-20
[8]:	https://jivimberg.io/blog/categories/effective-testing-series/