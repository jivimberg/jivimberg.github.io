---
layout: post
title: "AutoValue for Android"
date: 2014-04-20 17:14:00 -0700
comments: true
categories: android java lib 
---
Remember [my last post] on value types using [Google's AutoValue]? Today while doing some work on a new Android project I'm starting I thought: _'Great chance to use AutoValue!'_. Guess what, there is a port of Google AutoValue for the Android platform.

<!-- More -->

So the first thing I thought was: _'Why do I need an special port of the AutoValue in the first place?'_. Even though you could use the original [Google's AutoValue] and it will work just find, there are 2 reasons why you should consider the Android port:

1. Android AutoValue splits the project in 2 libraries. Only one is included in your apk (which just contains the interface) and the other is only used during compile time
2. Apart from all the things you get using the original lib the Android AutoValue also includes Parceable generation just adding `implements Parcelable` to your classes.

That's pretty much all. Head to the [Android Autovalue github repo] to see how to use it in your project. 


[my last post]: blog/2014/04/07/value-types-the-easy-way/
[Android Autovalue github repo]: https://github.com/frankiesardo/android-auto-value
[Google's AutoValue]: https://github.com/google/auto/tree/master/value