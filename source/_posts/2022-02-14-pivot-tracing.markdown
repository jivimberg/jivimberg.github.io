---
layout: post
title: "Pivot Tracing"
date: 2022-02-14 23:02:52 -0800
comments: true
categories:  papers observability distributed-tracing
published: false
---

Pivot Tracing lets users define arbitrary metrics over trace data at runtime. It does so by combining two powerful techniques:

1. The ability to **dynamically instrument code** without having to redeploy.
2. A **Happen-Before operator** that allows users to perform queries based on the causal relationship of the events.

<!--more-->

## How it works

Say we have an instrumented system we want to troubleshoot:

{% img center /images/posts/2022-02-14/pt1.jpg 700 %}

The first step is to define **Tracepoints** ⓵. Tracepoints are pointers to the source code where the code will be instrumented to collect metrics. They are instructions on _where_ and _how_ to modify the system to extract the required information. You can think of them as [_pointcuts_ from aspect-oriented programming][1]. They can refer to any arbitrary interface or method signature and can also be inserted at specific line numbers. 

Tracepoints export variables that can be used to write the queries, such as method arguments or local variables. Some default variables are provided out-of-the-box such as: _host_, _timestamp_, _process id_, _process name_, etc.

The cool thing about Tracepoints is that **they don’t need to be defined a priori**. And since defining a Tracepoint involves no code modification, **new ones can be created at no cost**.

Tracepoints are created by someone with good knowledge of the system (such as developers or operators). They **define the vocabulary users will use to write the queries**.

{% img center /images/posts/2022-02-14/pt2.jpg 700 %}

The next step is to write a query using the terms introduced by the tracepoints ⓶. A query might look something like this:

```sql
From incr In DataNodeMetrics.incrBytesRead
Join cl In First(ClientProtocols) On cl -> incr
GroupBy cl.procName
Select cl.procName, SUM(incr.delta)
```

In this example a Tracepoint exists for the method `DataNodeMetrics. incrBytesRead(int delta)`  and another one for the class `ClientProtocols`. The shown query sums the values of `incr.delta` grouped by ClientProtocol’s `procName`. The clause `On cl -> incr` establishes that we’re interested in only capturing `cl` events that happened before a `incr` event. **The cool thing is that these two tracepoints belong to two different services! Pivot tracing will know how to propagate the required context needed to do the join and evaluate the happens-before clause.** 

Once the user submits the query, Pivot Tracing frontend compiles it to something called **Advice** ⓷. An Advice contains the instructions that need to be executed when a request passes through a Tracepoint to answer the query. These are the operations that can be executed as part of an Advice:

* **Observe:** Creates a tuple from variables defined by a tracepoint.
* **Filter:** Evaluates a predicate on all tuples.
* **Pack:** Makes tuples available for use by later Advice
* **Unpack:** Retrieves one or more tuples from prior Advice
* **Emit:**Outputs a tuple for global aggregation.

The Frontend creates these Advices and notifies the PT Agents to install them in the corresponding Tracepoints ⓸.

{% img center /images/posts/2022-02-14/pt3.jpg 700 %}

This is done by _weaving_ generated code that gets executed every time a requests passes through the Tracepoint.

{% img center /images/posts/2022-02-14/weaving.png 700 %}

For the query shown above Advices A1 and A2 would be generated:

{% img center /images/posts/2022-02-14/generatedAdvices.png 700 %}

To do the happens-before join required by the query shown above Pivot Tracing needs to propagate the variables captured at `ClientProtocols Tracepoint` to the  `DataNodeMetrics Tracepoint`. This is done through something called _baggage_ (if you’re familiar with [OTel’s baggage][2] it’s basically the same thing).  When the request gets to the `ClientProtocols Tracepoint` the Advice A1 _Observes_ the variables and _Packs_ them as part of the request baggage ⓹. Later, when the code gets to the `DataNodeMetrics Tracepoint` the Advice A2 _Unpacks_ the variables, _Observes_ the value of `delta` and _Emits_ a joined tuple ⓺. 

{% img center /images/posts/2022-02-14/pt4.jpg 700 %}

The tuples emitted by `DataNodeMetrics Tracepoint` ⓺ are aggregated locally and then streamed to the client over the message bus ⓻. 

Finally, Pivot Tracing Frontend uses this tuples to answer the user’s query ⓼. And that’s how the whole thing works.

{% img center /images/posts/2022-02-14/pt5.jpg 700 %}

## The power of Happens-Before




## The pros and cons of Dynamic Instrumentation

Talk about:
*  Dynamic Instrumentation.
* Happens Before. Typical example of grouping metrics of service B by tags provided on service A (here A -\> B)

---- 

TODO

{% img right-fill /images/signatures/signature3.png 200 ‘My signature’ %}

[1]:	https://docs.spring.io/spring-framework/docs/3.0.x/spring-framework-reference/html/aop.html
[2]:	https://opentelemetry.io/docs/concepts/signals/baggage/