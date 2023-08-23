---
layout: post
title: "Jacoco & Gradle - How to verify coverage with exclusions"
date: 2018-04-26 08:49:52 -0700
comments: true
categories: gradle jacoco verify test coverage exclusions jacocoTestCoverageVerification
---

A post about how to add exclusions to your Jacoco test coverage verification in Gradle.

<!--more-->

This is how you setup Jacoco to fail when the code doesn’t meet the expected coverage threshold: 

{% gist ea79614ce9b80c29b03be8326586f238 %}

See that `rule`?  I’m not setting any particular `element` so [by default it’ll set _BUNDLE_][1]. **This is just what I want as I’d like to set a threshold for the coverage of the entire module.**

So if I need to exclude certain **packages** or **files** from the count this is what I do:

{% gist 3ee0beaa9ab8b20b48e4273378dcd30e %}

### Why _exclude_ doesn’t work

My first approach was setting the `excludes` property on the rule like this:

{% gist 0962942885d4db41a9dad890aba5d225 %}

The reason this doesn’t work is that `excludes` works on objects of the type defined with the `element` property. In this case the type is _BUNDLE_ whereas the thing we want to exclude are **packages** and **files**.



[1]:	https://docs.gradle.org/current/javadoc/org/gradle/testing/jacoco/tasks/rules/JacocoViolationRule.html#getElement--