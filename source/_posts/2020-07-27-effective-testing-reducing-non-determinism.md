---
layout: post
title: "Effective Testing - Reducing non-determinism to avoid flaky tests"
date: 2020-07-27 22:00:54 -0700
comments: true
categories: effective-testing-series testing tests non-determinism flaky 
---

Flaky tests are those that randomly fail for no apparent reason. If you have a flaky test, you might re-run it, over and over, until it succeeds. If you have a _couple_ of them, the chances of all passing at the same time are slim, so maybe you ignore the failures. You know, just this one time… Soon enough, you’re not paying attention to failures on this test suite. Congratulations! Your tests are now worthless.

<!--more-->

## Prefer smaller tests

Non-determinism is often introduced as a consequence of relying on external services. For example, let’s say our test needs to read data from a database, the test might fail if the database is down, or the data is not present, or has changed. 

You've probably seen the [Test Pyramid][1] before. Tests are classified by scope, and the recommendation is to favor tests with reduced scopes (i.e. Unit Tests). 

{% img center /images/posts/2020-07-31/TestingPyramid.jpg 700 ‘Using data classes for assertions’ %}

At Google they came up with a new dimension: _Test Size_[^1]. Tests are grouped in categories **based on the resources a test needs to run** (memory, processes, time, etc.). 

* **X-Small** tests are limited to a single thread or coroutine. They are not allowed to sleep, do I/O operations, or make network calls.
* **Small** tests run on a single process. All other X-Small restrictions still apply.
* **Medium** tests are confined to a single machine. Can’t make network calls to anywhere other than `localhost`.
* **Large** tests can span multiple machines. They're allowed to do everything.

_Scope_ and _Size_ are related, but independent. You could have an end-to-end test of a CLI tool that runs in a single process.

How does this tie back to our crusade against flaky tests? Simple, **the smaller the test, the more deterministic it’ll be.** As a bonus perk, they also tend to be faster.

{% img center /images/posts/2020-07-31/TestSizes.jpg 700 ‘Test sizes’ %}

Google went the extra mile and built infrastructure to enforce these constraints. For example, a test marked as _Small_ would fail if it tried to do I/O. 

## How to make your test small

Some ways you can reduce the size of your test:

1. Use [Test Doubles][2] to avoid making calls to external services.
2. Use an [in-memory Database][3].
3. Use an [in-memory filesystem][4].
4. Design your classes so that [test can provide a custom time source][5] instead of relying on the system clock.
5. Use [kotlinx-coroutines-test][6] to virtually advance time without having to make your test wait.
5. Use [Testcontainers][7] to turn a _Large_ test into a _Medium_ one.

## The trade-off

The downside of artificially isolating your tests is that they lose _Fidelity_. Meaning, what you end up testing is further away from what will run in production. [I’ve been bitten by this in the past][8].

The trick is to have a test distribution similar to the one proposed by the Test Pyramid. We should have lots of _Small_ and _X-Small_ tests, some _Medium_ tests, and only a few _Large_ tests.

---- 

This post is part of the [Effective Testing Series][9].

 {% img right-fill /images/signatures/signature2.png 200 ‘My signature’ %} 

[^1]:	The name is unfortunate as it’s not immediately obvious what Size refers to.

[1]:	https://martinfowler.com/bliki/TestPyramid.html
[2]:	https://martinfowler.com/bliki/TestDouble.html
[3]:	https://www.baeldung.com/spring-boot-h2-database
[4]:	https://github.com/google/jimfs
[5]:	https://github.com/google/guava/wiki/CachesExplained#testing-timed-eviction
[6]:	https://github.com/Kotlin/kotlinx.coroutines/tree/master/kotlinx-coroutines-test
[7]:	https://www.testcontainers.org/
[8]:	https://jivimberg.io/blog/2018/06/23/oracle-jpa-and-the-mistery-of-the-string-that-was-null/
[9]:	https://jivimberg.io/blog/categories/effective-testing-series/