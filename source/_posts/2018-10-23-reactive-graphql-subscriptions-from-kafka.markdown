---
layout: post
title: "Reactive GraphQL subscriptions from Kafka"
date: 2018-10-23 07:58:14 -0700
comments: true
categories: reactive graphql subscriptions kafka spring boot kotlin reactor 
---

In this post I’ll be exploring how to implement [GraphQL subscriptions][1] _reactively_ on a Spring Boot application using [Kafka][2]. 

<!--more-->

# The use case
So, _what are we trying to achieve?_ We want to provide **a way for clients to get notified** whenever an event occurs in the application.

The GraphQL way of doing this is through a [Subscription][3]. For the application events we’re using Kafka. So all we are trying to do is to tie those 2 things so that **whenever an event pops up in Kafka all clients with an active subscription get notified**.

{% img center /images/posts/2018-10-24/SubscriptionFlow.png 700 ‘Subscription flow diagram’ %} 

# The setup
Let’s introduce the different pieces of the puzzle: 

1. I have a [Spring Boot application][4] that has some business logic.
2. Using [`graphql-spring-boot-starter`][5] I’m exposing my service through a GraphQL API. **One of those endpoints it’s going to be a Subscription endpoint.** It’s schema definition looks something like this:

{% codeblock lang:java %}
type Subscription {
 event: EventMessage
}
{% endcodeblock %}

3. On the other end I have a [Kafka topic][6] with events that a user might be interested in. We plan to use [Reactor Kafka][7] to **consume the events through a reactive stream**.

{% img center /images/posts/2018-10-24/Setup.png 800 ’Setup diagram’ %} 

So the challenge is: _how do we connect all this pieces together?_

# Reactive all the way
To implement the resolver [GraphQL Java Tools][8] **requires that we implement a function that returns a `Publisher<T>`**. Where _T_ is the type of event to be pushed to the subscriber. From [GraphQL Java][9] documentation:

> What is special is that the initial result of a subscription query is a **reactive-streams Publisher object** which you need to use to get the future values.

On the other end **we can use [Reactor Kafka][10] to create a reactive Receiver** to consume the events from the topic. Then all that’s left is **obtaining a `Publisher` from this receiver so that clients can subscribe to it**. This is all the code we need:

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import graphql.schema.DataFetchingEnvironment
import org.reactivestreams.Publisher
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Component
import reactor.core.publisher.Flux
import reactor.kafka.receiver.KafkaReceiver
import reactor.kafka.receiver.ReceiverOptions

@Component
class SubscriptionsResolverImpl(
    receiverOptions: ReceiverOptions<String, EntityUpdated>                 // Receiver configuration. Injected by Spring
) : SubscriptionsResolver {

    private val logger = LoggerFactory.getLogger(javaClass)

    private val kafkaReceiver: Flux<GraphqlEvents.Update> by lazy {         // Use lazy to delay KafkaReceiver initialization
        KafkaReceiver.create(receiverOptions).receive()                     // Create Kafka reactive receiver
            .map { GraphqlEvents.Update.fromEvent(it.value()) }             // Map from Kafka event to Graphql Event
            .doFinally { logger.info("Closing with signal: ${it.name}") }   // Log message on stream closure
            .publish()                                                      // Get a ConnectableFlux. Turns stream to hot
            .autoConnect()                                                  // Connect to upstream on first subscription
    }

    override fun event(env: DataFetchingEnvironment): Publisher<GraphqlEvents.Update> {
        logger.info("GraphQL 'event' subscription called")              // Log message on each new subscription
        return kafkaReceiver                                                // Returns kafkaReceiver for GraphQL to subscribe to it
    }
}
</xmp>

Just to recap. We are **creating a Kafka Receiver** for the topic we care about (the topic configuration is part of the `receiverOptions` object, not shown in the snippet). 

We are **mapping the event** from the _Kafka model_ to the _GraphQL model_ through the `map()` method.

Then we are turning the receiver into a hot stream by calling `publish()`. We are doing this because **we want new subscribers to only see events that happened after they subscribed to the `Publisher`**. And that’s exactly what `publish()` does. In fact if you pay close attention to the marble diagram of the [method documentation][11] you’ll notice how **it looks pretty similar to our use case flow diagram.**

{% img center /images/posts/2018-10-24/publish.png 500 ‘Publish marble diagram’ %} 

We’re calling `autoConnect()` so that it connects to the upstream source as soon as the first `Subscriber` subscribes.

Finally we’re implementing the `event` function **by simply returning the reference to our hot stream of events**. Whenever a new client calls the Subscription endpoint **GraphQL Java will subscribe to this stream** and send a message for every new event that shows up in the configured Kafka topic.  

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[1]:	https://github.com/facebook/graphql/blob/master/rfcs/Subscriptions.md
[2]:	https://kafka.apache.org/
[3]:	https://github.com/facebook/graphql/blob/master/rfcs/Subscriptions.md
[4]:	https://spring.io/guides/gs/spring-boot/
[5]:	https://github.com/graphql-java-kickstart/graphql-spring-boot
[6]:	https://kafka.apache.org/documentation/#intro_topics
[7]:	https://github.com/reactor/reactor-kafka
[8]:	https://github.com/graphql-java-kickstart/graphql-java-tools
[9]:	https://github.com/graphql-java/graphql-java
[10]:	https://github.com/reactor/reactor-kafka
[11]:	https://projectreactor.io/docs/core/release/api/reactor/core/publisher/Flux.html#publish--