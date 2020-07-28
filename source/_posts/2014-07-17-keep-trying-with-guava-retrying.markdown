---
layout: post
title: "Keep trying with Guava Retrying"
date: 2014-07-17 14:22:07 -0700
comments: true
categories: guava java libs
---

We were having a [race condition][1] on a server which was "fixed" by adding an sleep to the thread to check again later. Yes, it sucked, so I decided to make something more sophisticated and went looking for a library to handle retries with multiple strategies. That's when I first read about [Guava Retrying][2].

<!--more-->

In the words of it's creator ([rholder][3]):

> Guava-Retrying is a small extension to Google's Guava library to allow for the creation of configurable retrying strategies for an arbitrary function call, such as something that talks to a remote service with flaky uptime.

### Quick example

Let's say we want to execute a task that will:

* Retry if the result is `null`
* Retry if an exception of type IOException is thrown
* Wait 300 milliseconds to try again.
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
        .withWaitStrategy(WaitStrategies.fixedWait(300, TimeUnit.MILLISECONDS))
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

After attempting 5 times it will throw a `RetryException` with information about the last attempt. Any other exception thrown by your task will be wrapped and re-thrown in a `ExecutionException`.

Other **wait strategies** supported are: [Random][4], [Incremental][5], [Exponential][6], [Fibonacci][7].

Other **stop strategies** supported are: [never stop][8], [stop after delay][9].

 {% img right-fill /images/signatures/signature4.png 200 ‘My signature’ %} 


[1]:	http://en.wikipedia.org/wiki/Race_condition#Software
[2]:	https://github.com/rholder/guava-retrying
[3]:	https://github.com/rholder
[4]:	http://rholder.github.io/guava-retrying/javadoc/2.0.0/com/github/rholder/retry/WaitStrategies.html#randomWait(long,%20java.util.concurrent.TimeUnit)
[5]:	http://rholder.github.io/guava-retrying/javadoc/2.0.0/com/github/rholder/retry/WaitStrategies.html#incrementingWait(long,%20java.util.concurrent.TimeUnit,%20long,%20java.util.concurrent.TimeUnit)
[6]:	http://rholder.github.io/guava-retrying/javadoc/2.0.0/com/github/rholder/retry/WaitStrategies.html#exponentialWait()
[7]:	fibonacciWait
[8]:	http://rholder.github.io/guava-retrying/javadoc/2.0.0/com/github/rholder/retry/StopStrategies.html#neverStop()
[9]:	http://rholder.github.io/guava-retrying/javadoc/2.0.0/com/github/rholder/retry/StopStrategies.html#stopAfterDelay(long,%20java.util.concurrent.TimeUnit)