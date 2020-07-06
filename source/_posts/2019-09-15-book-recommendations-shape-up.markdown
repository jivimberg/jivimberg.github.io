---
layout: post
title: "Book recommendations: Shape Up"
date: 2019-09-15 10:51:31 -0700
comments: true
categories: books book basecamp processes agile planning design
---

I love reading about how people do creative work. Be it [writing books][1] or [designing video games][2], there’s something magical about peeking behind the curtain and learning how the pros do their thing.

Today I’m reviewing [Shape Up][3], a book about the process of writing software at Basecamp.

<!--more-->

[{% img center /images/posts/2019-09-29/shapeUpCover.png 700 ‘Book cover’ %}][4]

(_I promise those potato shapes ☝️ will make sense by the time you finish the book_)

# What is it?

Shape Up is a book by [Ryan Singer][5] about how [Basecamp][6] (the company) writes [Basecamp][7] (the app). It goes through the development process, from the moment a new idea comes up, ‘till it shows up in production as a fully implemented feature.

# Why does it matter?

**Because it’s fresh!** This is not your run-of-the-mill _“How we do Agile”_ kind of book. There are no Kickoff meetings, no Kanban boards, no Daily Standup. They don’t even keep a backlog! 

Coming from the people that wrote [Remote][8] and [It doesn’t have to be crazy at work][9], you know this is a company that’s not afraid to innovate.

{% blockquote Jason Fried, Basecamp CEO %}
 Now that our process is fully formed, documented, and ready to go, we’re here to share it with all those curious enough to listen to a new way of doing things. Explorers, pioneers, those who don’t care what everyone else is doing. Those who want to work better than the rest.
{% endblockquote %}

Also, it doesn’t hurt that it is short, well-written, and has real-life examples and stick-figure drawings. **Oh! and it’s free!! 💸**

# So, what did you learn?

A bunch of things! I’m not going to cover everything because I wouldn’t be able to do it justice. Instead, I’ll focus on a couple of nuggets of wisdom. If you find them interesting, go check the book! Getting a better sense of how the whole process is structured shines a new light on the bits you’ll find described here.

## The shape of your task

A big part of the book is about what happens before the developer starts coding. It is about choosing and defining what’s going to be built. This is what Basecamp calls [_”Shaping”_][10], and it is so integral to their process that it’s right there on the book’s title. I found this refreshing since, more often than not, books will focus on the execution of tasks instead of how to come up with them.

Basecamp uses cycles of six weeks.  While the developers are busy delivering features, a group of senior staff members[^1] works on defining what’s going to come next. If the project is approved (more on this later), a team of developers will use this spec to make it happen on the next cycle.

The key to Shaping is that it has to happen at **the proper level of abstraction**. Go too abstract, and the dev team might end up building the wrong thing. Go too concrete, and they have no wiggle room to work around a technical pitfall or revise a design choice.

{% img right /images/posts/2019-09-29/knob.png 400 ‘Abstraction knob’ %}

For example, they’d use fat marker drawings instead of wireframes, to avoid delving too deep into the UI design details.

You want to end up with a good definition of the problem and a rough sketch of the solution. A clear sense of what’s part of the solution and what’s out of scope. A set of elements and how they connect to each other, but no comprehensive list of tasks or high-res mockups. Those things will come later when the dev team takes over and starts exploring the solution.

{% img left /images/posts/2019-09-29/fatMarker.png  150 ‘Fat marker sketch’ %}

Only once shaping is complete, they’d take it to the [_“betting table“_][11] where they decide if this is something they want to bet the next six weeks on. If the pitch is , it goes into the next cycle. If it’s not, then nothing happens. There’s no centralized backlog or list of rejected ideas. If somebody considers it important or thinks that a better solution can be found, they’ll lobby for it again six weeks later.

## Evaluating new ideas and user requests

Every single new idea and feature request gets the same answer: 

{% img center /images/posts/2019-09-29/interesting.png 400 ‘Interesting! Maybe some time’ %}

Basecamp believes an idea needs to go through the shaping process detailed above before they’re ready to bet on it.  When a new request comes in, they’d first try to identify what’s the user need (which sometimes might be quite different from what the user is asking for). Then, they see how they can solve the requirement with a minimal amount of effort. They acknowledge there’s always a better, more complete solution if you have infinite time at your disposal. The trick here is to find a good solution that works under the given constraints (in their case, that it can be built by a small team of engineers and designers in no more than six weeks) 

If they’re not able to narrow down the problem and it’s not critical, they simply let it rest and wait to see if the same problem shows up again, so they can get a better sense of what they’re solving for. **Grab-bags such as: “Redesign profile page” or “Refactor engine” are a no-go**. The scope has to be well-defined before they’re ready to bet on an idea.

## Showing progress

This is how we track progress in our industry:

{% img center /images/posts/2019-09-29/scrum.jpg  700 ‘Wall full of post-it notes’ %}

The problem with this approach is that it only works if all required tasks are known up-front. And let’s face, 99% of the time, that’s not the case. Most of the time, you’d start coding the first task only to discover that a new component needs to be added, and you’ll have to fix a few connections this change will introduce.

The book acknowledges this exploration phase as an inherent part of the developers' work. It makes the distinction between 2 different types of tasks: 

* **Imagined tasks**: Those thought about before you start coding
* **Discovered tasks**: Those you discover as you go.  

The tool they came up with to communicate progress are [Hill Charts][12], and they look like this:

{% img center /images/posts/2019-09-29/hillChart1.png  600 ‘Hill Chart’ %}

As you can tell, it’s not (only) a function of pending tasks, but also of confidence in that all remaining tasks have been discovered.

{% img center /images/posts/2019-09-29/hillChart2.png 600 ‘Hill Chart 2’ %}

A good way of gaining confidence at the start of a project is to begin with the pieces that present the most uncertainty, and move them to the top of the hill first. Doing this before finishing the downhill stuff reduces the chances the project will be late.

---- 

That’s all…

If you enjoyed the review, you’ll love the book. [Go check it out!!][13]

 {% img right-fill /images/signatures/signature5.png 200 ‘My signature’ %} 


[^1]:	Not sure why they’re not referred to as PMs in the book

[1]:	https://en.wikipedia.org/wiki/On_Writing:_A_Memoir_of_the_Craft
[2]:	http://the-witness.net/news/
[3]:	https://basecamp.com/shapeup
[4]:	https://basecamp.com/shapeup
[5]:	https://twitter.com/rjs
[6]:	https://basecamp.com/about
[7]:	https://basecamp.com/
[8]:	https://basecamp.com/books/remote
[9]:	https://basecamp.com/books/calm
[10]:	https://basecamp.com/shapeup/1.1-chapter-02
[11]:	https://basecamp.com/shapeup/2.2-chapter-08#the-betting-table
[12]:	https://basecamp.com/features/hill-charts
[13]:	https://basecamp.com/shapeup