---
layout: post
title: "Working with Queues"
date: 2020-05-30 19:29:39 -0700
comments: true
categories: architecture queues amazon aws sqs patterns
---

Queues are a powerful tool for building reliables systems. In this article, I’ll describe some of the tips and tricks I came across when working with queues. 

Some of the advice is specific to Amazon SQS queues because that’s what I’ve been using the most lately. And also because some of them come from [this amazing article][1] from the [Amazon Builders’ Library][2].

<!--more-->

## The trade-off

Queues can be used to increase our system’s availability by accepting new messages even if our service is down. When using systems like SQS, we also get a durability guarantee, because we know messages published won’t be lost if our system fails as they are persisted in the queue. Additionally, we get an increase in reliability since we can configure our system to retry the processing of a message in case of failure.

{% img center /images/posts/2020-06-07/Availability.png ‘Example of how queues can increase availability’ %}

These advantages come at a cost. **We get better reliability, availability, and durability at the price of increased latency**. Meaning, messages can take longer to be processed compared to a synchronous system. This is because our system might have to go through a backlog of old messages before getting to the one just published. Furthermore, if the pace at which messages are put on the queue is faster than the speed at which our system can process them, the system might never be able to catch up!

{% img center /images/posts/2020-06-07/Overflow.gif ‘Animation on how a slow consuming queue can overflow’ %}

Let’s go over some of the things we can do to prevent or mitigate these risks.

### 2. Wrapping your queues

Instead of exposing the queues to clients, you can wrap them with an ordering API. This way, we maintain more control over what’s published in the queue. Wrapping queues have many benefits:

1. We can run validations over the message payload and reject malformed messages with an appropriate error.
2. We can enrich the message payload with caller information.
3. We can authenticate callers to control access.
4. We can implement some of the patterns mentioned below to control fairness in a multi-tenant system and handle surges.

{% img center /images/posts/2020-06-07/WrapQueues.png ‘System diagram for wrapping queues’ %}

The downside of wrapping the queues is that we turn an asynchronous call into synchronous. Now our system has to be up to process new messages. We’re trading the availability improvements for more control.

### 3. Dealing with a backlog

The price of increased availability is having to deal with the backlog of messages that occur in a surge or after a failure. One way to do so is by dropping old messages.  When consuming a new message, we can compare the current time with the time the message was published and discard the message if it is greater than some value. Of course, this only works if the systems can tolerate this type of message loss.

Another technique is to move the excess to a spillover queue to be processed later. The system will first work on the new messages on the main queue, and only tackle the ones on the spillover queue once resources are available. This way, we can approximate LIFO order, which might be more appropriate for systems dealing with real-time events.

{% img center /images/posts/2020-06-07/Spillover.png ‘Diagram of a system using spillover queue’ %}

Finally, we can measure the size of the backlog and scale the number of consumers accordingly. Once the backlog is back to its normal size, we can scale down the consumer instances.

### 3. Ensuring fairness

One of the challenges of having multiple customers is having to guarantee fairness. That is, making sure one client is not exhausting all the available resources, creating significant latencies on other clients’ messages. This is especially true in multi-tenant environments where clients might not be aware they’re sharing resources with other people.

One possible solution is to have different customers publish to different queues, and have the system consume in a round-robin fashion. This is a simple solution, but it does not scale well. If we had thousands of customers, we’d have to manage and poll thousands of queues. Instead, we can have a fixed number of queues and hash each customer to a small number of them. Whenever we receive a message, we retrieve the queues assigned to that customer and put the message on the queue with the shortest backlog. That way, if a client is producing lots of messages on their queues, other workflows are automatically routed to less utilized queues.

{% img center /images/posts/2020-06-07/Sharding.gif ‘Animation of multi-tenant system using sharing’ %}

Another solution is to set a rate for messages processed for each customer. Once the customer has gone over the specified rate, messages are put in a spillover queue to be deal with later. This pattern is similar to the one we applied for old messages in the previous section, only in this case we’re using it to prevent one client from exhausting all the processing power.

### 3. Ensure enough capacity for surges

It is crucial to reserve additional resources to be able to handle spikes in traffic. One smart idea is to measure the number of messages retrieved while polling. If the system is retrieving more messages on every poll attempt, it means we probably don’t have enough spare resources to handle a surge.

### 4. Updating the visibility timeout

The way Amazon SQS works is that whenever a consumer receives a message, the message remains on the queue hidden. Other consumers won’t be able to see the message for a period of time known as _visibilityTimeout_. Once the _visibilityTimeout_ period is up, if the message has not been deleted from the queue, other consumers will be able to get it and process it.

If processing a message is taking too long, we run the risk of going over the _visibilityTimeout_ period. If that happens, another client will receive the message and start churning away, spending more resources on it, even though the first consumer has a better chance of finishing first. To avoid this, when we realize processing is taking too long, we can heartbeat SQS to let it know we’re still working. We do this by updating the _visibilityTimeout_ period for a particular message.

We can also use the ability to programmatically modify the _visibilityTimeout_ for a message to speed up retries. Say our queue is configured with a _visibilityTimeout_ of 10 minutes, and while processing a message, we face a transient error, we can set _visibilityTimeout_ to zero to make it retry faster.

 {% img right-fill /images/signatures/signature8.png 200 ‘My signature’ %} 

[1]:	https://aws.amazon.com/builders-library/avoiding-insurmountable-queue-backlogs/
[2]:	https://aws.amazon.com/builders-library/