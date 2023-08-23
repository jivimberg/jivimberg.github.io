---
layout: post
title: "Different kinds of Channels in Kotlin"
date: 2019-04-18 07:59:14 -0700
comments: true
categories: kotlin channels coroutines concurrency
---

Overview of the different kinds of Kotlin channels and their behaviors.

<!--more-->

{% img center /images/posts/2019-04-18/Channels.gif  600 ‘Channels animation’ %}

## Rendezvous

{% img right /images/posts/2019-04-18/baton.jpg 250 ‘Passing the baton’ %}

In Rendezvous channels capacity is 0. Which means the channel has no buffer at all. Elements are transferred only when sender and receiver meet. Which is literally what _Rendezvous_ means. I like to picture it as a [relay race][1] where the runners need to meet at one point to pass the baton.

In technical terms this means that `send` _suspends_ until another coroutine invokes `receive`, and `receive` _suspends_ until another coroutine invokes `send`.

## Buffered

Buffered channels have a positive capacity but are not `Unlimited`. Calling `send` _suspends_ only if the buffer is full. And calling `receive` _suspends_ only if buffer is empty (i.e. there are no more messages in the channel).

## Unlimited

You guessed it. Unlimited buffer. Sender will never _suspend_ on `send`. 

But there’s no such thing as _Unlimited_, right? The implementation uses a linked-list buffer so your only constraint is memory.

## Conflated

This is the oddball. The sender never _suspends_, but the channel offers at most one element at any given time. When a new element comes, the previous element in the channel (if any) is discarded. The receiver only gets the most recent element sent. Previous elements are lost.

{% img right-fill /images/signatures/signature7.png 200 ‘My signature’ %} 

[1]:	https://en.wikipedia.org/wiki/Relay_race