---
layout: post
title: "Book recommendations: Migrating to Cloud-Native Application Architectures"
date: 2018-07-24 16:18:45 -0700
comments: true
categories: microservices book cloud-native
---

Complementing [my last book recommendation][1] on _ Migrating to microservices databases_ by [Edson Yanaga][2] now I present [_Migrating to Cloud-Native Application Architectures_][3] by [Matt Stine][4].

<!--more-->

[{% img center /images/posts/2018-07-28/cover.jpg ’Migrating to Cloud-Native Application book cover’ %}][5]

I’m really digging this O’Reilly booklet style! They **condense a good overview of a specific topic in one-sitting books**. While at the same time provide enough links and resources to keep you digging for a few afternoons if interested.

Matt’s book is divided in 3 parts. The first bit **”The rise of cloud service”** serves as an introduction to the topic. It defines _cloud native architectures _ key characteristics and **why you might consider using one**.  If you are already familiar with the subject you may want to skim through this first section.

The second part is the one I enjoyed the most. It talks about **the changes needed to go cloud native**. It covers areas that are sometimes forgotten or considered as an afterthought such as _team collaboration_, _organizational changes_ (the [Inverse Conway Maneuver][6]) and the _decentralization of decision making_. The rest of the chapter touches on the **technical challenges** required. It was really nice to see a bit on how to **use [DDD][7] to identify service boundaries** when decomposing data models.

On the last chapter, called **Migration Cookbook**, Matt explores different strategies for decomposing the monolith (such as _”strangling the monolith”_, _”new features as Micro-services”_, _”anti-corruption layer”_, etc.) and provides links to articles by companies that applied this strategies on their own systems. The book finishes with a section called **Distributed system recipes**  where some of the more common _“challenges”_ of a cloud-native architecture are explored and particular solutions are presented using [Spring Cloud][8] and [Netflix OSS][9]. Here you’ll find things like _service discovery_, _versioned configuration_, _load balancing_, etc. Each topic is presented with a brief description of the problem, a mention of the Netflix OSS solution (and it’s features) and a code snippet showing how to integrate it with Spring.

## Bottom line
**GO READ IT!** It won’t take you more than an afternoon and chances are you’ll learn something new. You’ll walk away with **a better understanding of the cloud-native landscape.**

[1]:	https://jivimberg.io/blog/2018/05/25/book-recomendations-migrating-to-microservices-databases/
[2]:	https://twitter.com/yanaga
[3]:	https://content.pivotal.io/ebooks/migrating-to-cloud-native-application-architectures
[4]:	@mstine
[5]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[6]:	https://www.thoughtworks.com/radar/techniques/inverse-conway-maneuver
[7]:	https://en.wikipedia.org/wiki/Domain-driven_design
[8]:	http://projects.spring.io/spring-cloud/
[9]:	https://netflix.github.io/