---
layout: post
title: "Book recomendations: Migrating to microservices databases"
date: 2018-05-25 07:32:00 -0700
comments: true
categories: book microservices database data 
---

Just finished reading _ Migrating to microservices databases_ by [Edson Yanaga][1]. If you can relate to the 3 nouns in the title then you’ll want to check it out.

<!--more-->

> Code is easy; state is hard. 
> 
> — _Edson Yanaga_

If you are on the journey of **migrating your monolith to a micro-service architecture** (like every other developer this days) then, at some point, you probably found yourself staring at a whiteboard full of rectangles and hexagons thinking: _where does the data fit in this mess?_

Maybe you’ve read about the [“Database per service”][2] pattern and now you’re wondering what your requirements are on [data consistency][3]. Or somebody told you about [CQRS][4] but you don’t know it’s advantages and disadvantages.

[{% img center /images/posts/2018-05-26/MigratingToMicroservicesDatabases.png ’Migrating to Micro-services databases book cover’ %}][5]

Edson’s book opens with a brief recap of the micro-service world. Going from _“Why microservices”_ to [A/B testing][6] and [Canary deployment][7], the book provides a **super-quick explanation of each concept without going into many details.**

By contrast the second part of the book deeps dive into **how to handle the data** of your micro-services. _Chapter 3_ explains how to do **Zero downtime migration** of your relational DB and which tools to use. 

On _Chapter 4_ Edson introduces the different **consistency models** and compares **CRUD Vs. CQRS** (explaining also _Event sourcing_)

**The last chapter is, to me, the best.** _Chapter 5_  contains a recount and description of some of the different **Integration Strategies** we might want to consider when _migrating the monolith_. Each strategy is briefly described, and we are also provided with an assessment of **applicability** and section of **considerations** to keep in mind if using this strategy. 

## Conclusion

The hardest part of design is not knowing the architectural patterns or the different techniques to solve a problem, but **knowing which solution is a good fit to which problem.** Yanaga’s book serves as a good **catalog of possible solutions** to consider, when working with data on micro-services. It provides a concise analysis of each **strategy** and helps us avoid those  _”I wish I’ve thought this better before writing the code”_ moments.

[1]:	https://twitter.com/yanaga
[2]:	http://microservices.io/patterns/data/database-per-service.html
[3]:	https://en.wikipedia.org/wiki/Consistency_(database_systems)
[4]:	https://martinfowler.com/bliki/CQRS.html
[5]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[6]:	https://en.wikipedia.org/wiki/A/B_testing
[7]:	https://martinfowler.com/bliki/CanaryRelease.html