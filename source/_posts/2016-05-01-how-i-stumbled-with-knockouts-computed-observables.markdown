---
layout: post
title: "How I stumbled with Knockout's computed observables"
date: 2016-05-01 15:01:16 -0700
comments: true
categories: Knockout javascript
---
The first thing you learn about Knockout is about [observables][1]. The second thing is [computed observables][2]. They are dead simple. They even form part of the [Hello World example][3]. But then, the magic was not working for me. Here's why:

<!--more-->

In a nutshell **computed observables** are functions that are dependent on one or more other observables, and that will automatically update whenever any of these dependencies change.

<script async src="//jsfiddle.net/rniemeyer/LkqTU/embed/js,html,css,result/dark/"></script>

On my usecase I wanted the computed to updated only if certain condition was met. So I used a variable and a good old if. 

<script async src="//jsfiddle.net/jivimberg/uza8ds21/embed/js,html,css,result/dark/"></script>

I also added a toggle function to be able to change the value of the `bindingActive` variable from the UI. So the `fullName` should get updated once I toggle the boolean variable. **Guess what? it doesn't!**

Go ahead, give it a try. Turn on the toggle using the link and you'll notice that the message does not appear as it did on the Hello World example.

I spent half a day looking for an answer of what I was doing wrong. Until I decided to do what I should've done in the first place. Instead of regarding some new technology as magic, I went ahead and read the documentation to actually understand how it works.

So here's how the [dependency tracking algorithm][4] works according to KO documentation:

> 1. Whenever you declare a computed observable, KO immediately invokes its evaluator function to get its initial value.
2. While the evaluator function is running, KO sets up a subscription to any observables (including other computed observables) that the evaluator reads. The subscription callback is set to cause the evaluator to run again, looping the whole process back to step 1 (disposing of any old subscriptions that no longer apply).
3. KO notifies any subscribers about the new value of your computed observable.

Notice what's going on? Since `bindingActive` initial value is _false_ the tracking algorithm does not see the observables on it's first past. Therefore the **computed observable is not suscribed to update when any of the observables change!**

### How can we fix this?

Well a simple solution would be to define the toggle as an observable too. That way the computed observable suscribes to the toggle var observable and it gets recomputed when the variable changes.

Note that afterwards the step 2 of the tracking algorithm is designed to recognized the new observables that it missed the first time. That's quite nice! Only in our case since no observable was seen at all the computed observable was never updated.

Here's how such solution would look like:

<script async src="//jsfiddle.net/jivimberg/ymucehk2/embed/js,html,css,result/dark/"></script>

Another way of solving this issue would be to call the observables for `firstName` and `lastName` outside the if. That works too, but I like the other approach better. 


[1]:	http://knockoutjs.com/documentation/observables.html
[2]:	http://knockoutjs.com/documentation/computedObservables.html
[3]:	http://knockoutjs.com/examples/helloWorld.html
[4]:	http://knockoutjs.com/documentation/computed-dependency-tracking.html