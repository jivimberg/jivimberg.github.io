---
layout: post
title: "The whiteboard interview is broken"
date: 2020-05-09 17:48:02 -0700
comments: true
categories: interviewing interview hiring whiteboard
---

We have deluded ourselves into thinking that being able to invert a binary tree on a whiteboard is the hallmark of great software engineering. It’s time we look for better ways of evaluating coding skills.

<!--more-->

<blockquote class="twitter-tweet  tw-align-center"><p lang="en" dir="ltr">Hello, my name is David. I would fail to write bubble sort on a whiteboard. I look code up on the internet all the time. I don&#39;t do riddles.</p>&mdash; DHH (@dhh) <a href="https://twitter.com/dhh/status/834146806594433025?ref\_src=twsrc%5Etfw">February 21, 2017</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Why whiteboard coding doesn't work

The whiteboard code interview is a poor predictor of candidate performance because it only focuses on a narrow subset of skills that are rarely used on the day-to-day job. Think about it, when was the last time you had to write a merge sort from scratch and without googling?

**Whiteboard coding imposes a set of arbitrary limitations that look nothing like the tasks the candidate will perform once it’s hired. **

We make candidates write code on a whiteboard where refactoring is virtually impossible. We don’t allow them to look stuff up on Google or bounce ideas off a teammate. They’re supposed to have all the knowledge required to solve the problem in their head and come up with a good solution on the spot. To make matters worse, they’re placed under an artificial time constraint with the added stress of being watched perform.

At their best whiteboard interviews can testify to a good level of puzzle solving, some knowledge of data structures, and the ability to retain multiple indexes in your head to simulate a whiteboard code execution. All skills specifically [learned and practiced for the occasion][1]. A whole industry has spawned around helping engineers ace the whiteboard interview: [books][2], [platforms][3], [talks][4]. And don’t get me wrong, they really work!

But whiteboarding fails to test for things that more closely correlate to _good_ software development. It says nothing about whether the candidate can write clean code. It doesn’t tell you if they can navigate a project and introduce changes. If they’re good at refactoring code and working at the right level of abstraction.  If they know how to design and evolve an API. If they’re proficient at troubleshooting and debugging issues. In essence, whiteboarding fails at telling us whether the candidate can write maintainable code that will last longer than the 40 minutes of the typical coding interview. 

<blockquote class="twitter-tweet  tw-align-center"><p lang="en" dir="ltr">Google: 90% of our engineers use the software you wrote (Homebrew), but you can’t invert a binary tree on a whiteboard so fuck off.</p>&mdash; Max Howell (@mxcl) <a href="https://twitter.com/mxcl/status/608682016205344768?ref\_src=twsrc%5Etfw">June 10, 2015</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

## Then why do we do it?

Some would say the witheboard interview is a rite of passage people need to go through before joining the company. _“I went through this experience and did good so the new candidate should do it too”_. For the most part I don’t believe that’s the main reason. I think we just repeat what we’ve seen from other engineers/companies without stopping to think why we do it this way.

I don't know a single engineer that enjoys interviewing. I’d go as far as to say that some of us dread the task. So whenever we’re assigned with evaluating a candidate on their code skills we take the easy way out. We look up some clever interview questions, we study the answers and possible followups, and we roll with it. Thus perpetuating the tradition of whiteboard interviews. To make matters worse, most of the time we are neither trained for nor evaluated on how we conduct the interview. And since the impact tends to be long-term and hard to measure people are not really motivated in investing time to improve the process.

## What should we do instead?

**Simple: we should test people in problems and environments as close as possible to what they’ll be doing on the job. **

For example, [Pivotal Labs][5] have the candidate spend a full day pair-programming with the interviewer. No tricky algorithmic puzzle, no whiteboard. A real task at hand and dev-to-dev collaboration.

Another option is to provide a take home exercise. There’s no artificial time constraint, they can use any 3rd party library and Google whatever they need. Afterwards, you can use the submitted code as a starting point for the on-site and ask the candidate to iterate on the solution, either by building a new feature, improving the performance or working around some limitation.

Yet another option is to give the candidate some code and ask them to refactor it to introduce a new functionality.

One clever thing I've seen one of my colleagues do at Netflix is to introduce a bug in one of the apps the team maintains, then tell the candidate what users are experiencing and ask them to find the bug and fix it. He assists the candidates with the context needed to understand how the system behaves and nudges them in the right direction if they start going into a rabbit hole.

The ideal scenario, of course, is to have the candidate work with the team for a couple of months before making a decision. That’s why it’s probably easier to hire people already contributing to Open Source projects your company maintains. Unfortunately most of the time this is not really feasible.

---- 

Improving the coding interview takes time. But it’s hard to think of a better way investment than something that’ll help you hire great software engineers. Hopefully with time we’ll see less and less whiteboard interviews.

 {% img right-fill /images/signatures/signature4.png 200 ‘My signature’ %} 

[1]:	https://jivimberg.io/blog/2019/01/10/how-to-prepare-for-the-silicon-valley-interview-part-2/
[2]:	https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850
[3]:	https://leetcode.com/
[4]:	https://www.youtube.com/watch?v=8T7a09V1KZo
[5]:	https://blog.jonrshar.pe/2016/Dec/05/pivotal-interviews.html