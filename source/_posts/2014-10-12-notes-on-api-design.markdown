---
layout: post
title: "Notes on API Design"
date: 2014-10-12 15:34:29 -0700
comments: true
categories: ["Software Design"]
---
This is from a presentation I gave at work about how to design APIs that don't suck. You can download the whole presentation from [here]

<!-- more -->

##3 aspects of a good API##

{% img left /images/posts/2014-10-12/Discoverability.jpg 250 'Discoverability' %} 

**Discoverability:** Is how easy is for a user to access to the exposed functionality. We should always remember that our API is only a tool: a means to an end. The user wants to understand as little as possible to confidently achieve his goal.

{% img right /images/posts/2014-10-12/Consistency.jpg 250 'Consistency' %} 
<br>

**Consistency:** Helps improving the usability by reusing the same patterns across the whole API consistently. This way we beneffit from reusing the concepts the user has already learned.

{% img left /images/posts/2014-10-12/Stability.jpg 250 'Stability' %} 

**Stability:** There are 2 different types of stability that we need to be aware of:

1. **Backward compatibility:** Your changes you introduce in your new version of your API must not break the apps of your users written against a previous version. To achieve this one of the best tools you have is testing. Investing time in writing tests early will result in the ability to change your API confidently, knowing that if the tests are passing then you have achieved backward compatibility
2. **Conceptual Stability:** The user has build a conceptual model of how the API works. If possible we should avoid changing the concepts he has already learned. This one is even trickier to achieve because there is no exact way of testing it. 

##4 Principles to avoid complex APIs##

{% img left /images/posts/2014-10-12/EconomyOfConcepts.jpg 250 'EconomyOfConcepts' %} 

**Economy of concepts:** Minimizing the concepts introduced in your API will result in a flatter learning curve. A good way to achieve this is by making your API coexists with the platform. For example: avoid introducing new collections the user has to learn how to use, reuse known design patterns, honour the language naming convention, etc.

{% img right /images/posts/2014-10-12/Symmetry.jpg 250 'Symmetry' %} 

**Simetry:** Once more a simmetric API is easier to learn because it is more predictable. For example: if the user sees a method called `open()` he proabably will know that there is another called `close()` that he should call at the end, and so on and so forth.

{% img left /images/posts/2014-10-12/Naming.jpg 250 'Naming' %} 

**Naming:** Always use the same name for the same concept. Devs tend to get creative when naming things and that's a bad idea! If we, for example, use the term *'create'* in one place and *'build'* in another, it becomes very difficult to understand which is the pattern behind the design of the API. When used appropiately a a simple name we can communicate a complex concept with little or no ambiguity. As a rule of thumb if we are having a hard time naming some component then perhaps it's responsibility is not clear enough and we should review our design.

{% img right /images/posts/2014-10-12/MinimizeAccessibility.jpg 350 'Minimize Accessibility' %} 

**Minimize Accessibility:** Similar to encapsulation in Object Oriented Design, we should hide all the details the user doesn't need to know about. This way we are able to change those things under the hood without loosing backward compatibility. This maximizes information hiding and simplifies the use of the API, avoiding confusion by eliminating unnecessary choices.

##6 Helpful tips##

{% img left /images/posts/2014-10-12/UseCaseDriven.jpg 250 'Use case driven' %} 

**Use case driven:** It is useful to validate the possible use cases with future users of the API as soon as possible. One good trick is to start writing code against the API even when the implementation is not ready yet. 
An advantage of using use cases is that since we intereract with the API through code each use case can be easily translated into a test case. Furthermore using a TDD approach will provide some feeling on the usability of the API.

{% img right /images/posts/2014-10-12/WhenInDoubt.jpg 250 'When in doubt leave it out' %} 

**When in doubt...:** One of the most difficult choices an API designer is faced with, is deciding what stays and what goes. In general, if there isn't a great use case supporting a piece of the API, we're better off not having it there in the first place. *Remember: you can always add to an API, but you almost never can remove from it.* APIs are "add only"!

{% img left /images/posts/2014-10-12/Documentation.jpg 350 'Documentation' %} 

**Documentation:** It's well known that devs don't read the documentation. Luckily if your API is discoverable then your users won't need much documentation. 2 tips on this regard:

1. Document by exception: Focus only on what the user needs to know
2. Use lot of examples: In fact if you could only write one thing make it a example.

{% img right /images/posts/2014-10-12/Change.jpg 250 'Plan for a change' %} 

**Plan for a change:** In any successful API, the only constant is change. Features change, users request new features, we realise we made some obvious mistakes. Our API will change and we better be ready for it. When changing your API make sure to review your initial assumptions.

{% img left /images/posts/2014-10-12/DontDoEverything.jpg 250 'Don't do everythng' %} 

**Don't do everything:** It is as important to know what you won't do than knowing what you do. You have to always be open to breaking an API into several modules. Sometimes it us better to have two small APIs that one large one.

{% img right /images/posts/2014-10-12/ImplVsInterface.jpg 350 'Implementation Vs Interface' %} 

**Implementation != Interface** It is important to be clear on what it's an implementation detail and what is essential to the API. Exposing implementation details confuse the user and limits our freedom to change the API later on. For example: Avoid describing specific algorithms, avoid including tuning parameters, avoid specifying hashing functions. Focus on results, not means.

[here]:/downloads/ApiDesignKeynote.zip