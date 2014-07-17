---
layout: post
title: "Keep trying with Guava Retrying"
date: 2014-07-17 14:22:07 -0700
comments: true
categories: guava java lib
---

We were having a [race condition] on a server which was "fixed" by adding an sleep to the thread to check again later. Yes, it sucked, so I decided to make something more sophisticated and went looking for a library to handle retryies with multiple strategies. That's when I first read about [Guava Retrying]

<!--more-->

In the words of it's creator ([rholder]):

>Guava-Retrying is a small extension to Google's Guava library to allow for the creation of configurable retrying strategies for an arbitrary function call, such as something that talks to a remote service with flaky uptime.

Simply put give it a taks and it will retry it until success... or until a given condition is met, or after X attempts, or until it does not throw exception, or... well you get the point: **flexibility**.

### Quick example ###

Let's say we want to execute a task that will:
* Retry if the result is null
* Retry if an exception of type IOException is thrown
* Wait 300 miliseconds to try again.
* Stop after 5 attempts

Then we would do something like:

``` java
Callable<Boolean> yourTask = new Callable<Boolean>() {
    public Boolean call() throws Exception {
        return true; // do something interesting here
    }
};

Retryer<Boolean> retryer = RetryerBuilder.<Boolean>newBuilder()
        .retryIfResult(Predicates.<Boolean>isNull())
        .retryIfExceptionOfType(IOException.class)
        .withWaitStrategy(WaitStrategies.fixedWait(300,                                                                             TimeUnit.MILLISECONDS))
        .withStopStrategy(StopStrategies.stopAfterAttempt(5))
        .build();

try {
    retryer.call(yourTask);
} catch (RetryException e) {
    e.printStackTrace();
} catch (ExecutionException e) {
    e.printStackTrace();
}
```

After attempting 5 times it will throw a `RetryException` with information about the last attempt. Any other exception thrown by your task will be wrapped and rethrown in a `ExecutionException`

Other **wait strategies** supported: Random backoff, Incremental backoff, Exponential backoff, Fibonacci backoff

Other **stop strategies** supported: never stop, stop after delay.



[race condition]: http://en.wikipedia.org/wiki/Race_condition#Software
[Guava Retrying]: https://github.com/rholder/guava-retrying
[rholder]: https://github.com/rholder