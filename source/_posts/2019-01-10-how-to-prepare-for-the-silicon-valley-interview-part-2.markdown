---
layout: post
title: "How to prepare for the Silicon Valley interview - Part 2"
date: 2019-01-10 22:42:31 -0800
comments: true
categories: interviewing job silicon valley interview hiring tips interview-series
---

Welcome to the second part of the [Interviewing Series][1]! This time I’ll cover the thing that terrifies most candidates[^1]: **the technical questions**. We’ll see what the different types of questions are, and how to prepare for them. We have a lot of ground to cover so let’s jump right into it.

<!--more-->

{% img center /images/posts/2019-01-10/processFocus2.png 750 ‘Process timeline focus part 1’ %} 

# Programming questions

Programming questions are the heart of the technical interview and thus what you’ll spend more time preparing. 

Some people believe that [_the technical interview model is completely broken_][2]. I don’t really know if [technical interviews work or not][3], I just know that **they're part of the game, so you'd better prepare for it**. Having said that, if you are really against _"whiteboard interviews"_ [check this list][4] of companies that don’t rely on these kind of questions. Just keep in mind that _you might be limiting your options_.

Regardless the type of interview, one thing is certain: you’re better off preparing for it in advance. So let’s start by talking about some of the resources I used to practice.

## Cracking the coding interview (6th edition)

I’ve mentioned this book in [my previous article][5]. [Cracking the coding interview 6th edition][6] (CTCI from now onwards) by _[Gayle Laakmann McDowell][7]_ is the **holy bible of interviewing**.

[{% img center /images/posts/2019-01-10/ctci-cover.jpg 300 ‘Cracking the coding interview 6th edition’ %}][8]

I like it because **it’s remarkably complete**. It includes a description of the different interview processes at some of the big companies (Apple, Google, Facebook, etc.), it provides tips on how to set up a good resume, it covers the basics on Big O notation and _[much, much more…][9]_

The technical exercises are organized by topic. Each chapter includes a _brief introduction_ of the topic at hand (around 3 pages) and a _list of problems _sorted from easy to hard. This organization is nice because if you don’t have much time or don’t want to focus on a particular area you can simply skip that chapter altogether. I, for example, glossed over the _”Java”_ and _”Databases”_ chapters (Chapters 13 and 14 respectively) and skipped the _“C and C++”_ chapter (Chapter 12).

One of the best things about this book is that **each exercise comes with a series of hints in case you get stuck**. I love this because it mimics what would happen in a real interview, where the interviewer nudges you in the right direction to unblock you. Also in some of the more complex problems **the book presents multiple solutions and compares the different approaches**. Again, something that would probably come up in a real interview.

**Pro-tip:** If you live in the Bay Area your local library might have [a copy of the CTCI][10]. Having said that, if you have the money this is one of the best investments you can make for your career.

## LeetCode

The other thing I used to practice daily was **[LeetCode][11]**. There are a number of sites you can use to practice (here’s a [video comparing the most well-known][12]); I went with LeetCode because it was **explicitly designed for technical interviews** and it has support for [Kotlin][13]. 

One thing I like about LeetCode is that it _provides tests results after submission_ so you can figure out what you did wrong. Another useful feature is that it ranks your submission based on performance so you can see how well you did, compared to other solutions.

{% img center /images/posts/2019-01-10/leetcode-submission.png 750 ‘Leetcode submission comparison’ %} 

Where it falls short is in the solution explanation. **Only a small fraction of the problems have [official articles covering the solution][14] and the different alternative implementations.** For the rest of them, you’ll have to resort to the discussion forum, in the hopes that somebody there posted his/her answer, and the code is readable.

I didn’t pay for the premium account and didn’t try the _System Design_ questions, so can’t comment on that.

## Practice tips

### Use a whiteboard

You want your practice to be as close to the real thing as possible. That means you’ll have to resist the temptation of using your favorite IDE and go full whiteboard. It will be weird at first. Everything will take more time, you’ll run out of space and _end up using \* and arrows all over the place to add extra variables_. But guess what? **That's going to happen in the real interview too**. So you'd better get some practice on whiteboard coding before going in.

Don’t worry, nobody expects you to memorize all [Java Collectors][15]. It’s OK to ask the interviewer for the details of a particular method signature.

Having no IDE also **prevents you from writing automated tests for your problems**. Which (_for once_) is a good thing! You won’t have the luxury of unit testing your code during the interview either. Having said that you should still THINK about the tests you’d write, and even _whiteboard-debug_  some of them (see below 👇).

### Build the habit

Sometimes you’ll find it hard to sit down and practice. Here are some things that helped me:

1. **Find a time of the day that works for you and stick to it**. For example, I’m a morning person. I’d _wake up one hour earlier_ each day and practice before breakfast.
2. **Avoid distractions**. Apart from waking up before everyone else _I made sure my phone stayed in airplane mode_ at least until I'd finished one full problem.
3. **Prepare things beforehand**. Before going to bed _I’d set things up so that everything was ready in the morning_. Waking up to a clean whiteboard, the computer charged and [CTCI][16] opened in the right page gives you _fewer chances to slack or make excuses_.
4. **Set yourself achievable goals**. I found that not finishing my morning practice goal made me anxious during the day 😰. So I figured it was best to set realistic goals, so that _after completing the morning exercise I could feel good about myself for the rest of the day_.
5. **Know when to stop**. Don’t get too caught up on one problem. If you get stuck, just drop it for the time being, or move to another exercise. [_”The best debugger ever made is a good night's sleep.”_][17]

Problems might seem hard at first, but I promise that once you get the knack of it they’ll flow more easily. To the point where you’d eyeball a problem and have a pretty good idea of how you’d solve it.

## While solving the exercise

### CTCI Cheatsheet

The best advice I could find on how to tackle a problem is from [Cracking the coding interview][18]. Luckily they’ve put together this amazing cheat-sheet with a step by step guide:

[{% img center /images/posts/2019-01-10/ctci-cheatsheet-1.png 750 ‘CTCI cheatsheet’ %}][19] 

_(It’s also a great example on how  **NOT** to lay out an ordered list of items)_

### Talk through the problem

The whole point of having you solve an exercise during an interview is to provide the chance for the interviewer to evaluate how you approach a problem. So the best thing you can do to help your interviewer's job is to **speak through your thought process**.

It'll probably feel odd at first because usually, this happens as an internal monologue in your head, so make sure you practice this even when you’re solving problems on your own.

On the real interview, start by listening to the problem carefully and **asking clarifying questions** (_does the input fit into memory?_ _how often is this code going to be executed?_ etc.). Then walk your interviewer through each of the steps you take to arrive at the solution. If you’re going to _start by trying an example_ say it so, if you’re coming up with a _brute force solution first_ make that explicit, if you think the code could be refactored to be more legible express it. You’ll get extra points for mentioning these things, and in some cases, you _might be told not to focus on that_, and you’ll benefit from not wasting your time in a detail that was not meaningful to the interviewer.

> It is ok to be in silence only when you’re thinking. The rest of the time you should be explaining what you’re doing. **Especially while coding**.

### Problem checklist

There are a number of things you should consider on every problem you face:

* Are you handling nulls properly?
* Have you handled border cases? (empty collections, empty strings, negative integers, etc.)
* Have you considered overflow on arithmetic operations?
* Is the input sorted?
* If it is a collection: can it have duplicates?
* Does the input fit in memory?
* Can a better solution be found or have you achieved the best possible runtime?
* Can you trade space for time? (Think: HashMaps and [memoization][20])
* Can you pre-calculate something to speed things up? 
* Can you split the problem in smaller parts?
* Is your solution thread safe? If not, how can you make it?
* Is there any state you can save to make future runs faster?

### Whiteboard debugging

On [CTCI cheat-sheet][21] step #7 is _Test_. What I like to do for testing my solutions is what I call _"whiteboard-debugging"_. This is how it goes: 

1. Choose a good input example to work with (not too big, not trivial, not a corner case, etc.). 
2. Now _step through the code step by step_ as if you were debugging it.
3. Use a color marker to _write down the variable values_ as comments just like your IDE would do. 
	 
It should look something like this:

{% img center /images/posts/2019-01-10/isPalindrome.png 600 ‘Whiteboard debugging example’ %}

For this technique to work the only trick is to **suppress your instinct to jump ahead**. With the interviewer watching you'll get anxious and will want to speed things up by skipping a _"trivial loop"_ or just jumping to the result. DON'T DO IT! Step through the code one line at a time just like the compiler would do. This is the only way you'll find 🐞 in your code. 

And of course pay extra attention to hot spots like _arithmetic expressions_, _null nodes_ and _loop conditions_ (always check for off-by-one errors!).

### Stick to one language

It's no secret that I'm super hooked with [Kotlin][22] (some of my friends would even say I'm a fanboy), so I figured I'd practice the programming questions in Kotlin too. The problem was that Kotlin is not that widespread ([yet][23]), so __most of my interviews required me to write code in Java__. Kotlin and Java are fairly similar languages and yet I noticed that writing solutions in Java was taking me longer because of small things like having to look up the exact method I wanted to use. In one of my on-sites, for example, I mixed up the Java `switch` syntax with Kotlin's `when`. And while this isn't a huge mistake, it did raise a valid flag for the interviewer.

__That's why my advice is to pick one mainstream language and stick with it for both: practice and interviews.__

# Open problems

In my experience, open problems _are not that common_. When you're presented with one of these questions your main focus should be on clarifying the goal. **Ask as many followup questions as you can and don't make any assumptions** (or if you do validate them with the interviewer). _Don't just jump to the answer!_ Usually, this kind of exercises are more about seeing how the candidate approaches the problem rather than getting an actual solution.

# Language trivia

To my surprise, I _did_ find a fair share of language trivia questions. Things like [removing an item while iterating a collection][24] or [when to use `AtomicInteger`][25].

As you can tell, these are knowledge-based questions, so either you know the answer or you don't. __If you don't just be frank about it__, trying to guess the answer might backfire and make you look like a fraud.

If you're proficient with the language you'll have no problems answering these kind questions. If you want some practice CTCI has one chapter on _Java_ and another one on _C_ and _C++_. 

# System design questions

{% blockquote The System Design Primer %}
The system design interview is an <b>open-ended conversation</b>. You are expected to lead it.
{% endblockquote %}

The best resource I know to prepare for the System Design interview is [The System Design Primer][26] (thanks _Pablius_ for the tip!). Additionally, you should you should **regularly read engineering blogs** to learn how different challenges are solved in different companies. Some of the best ones are: [Netflix Tech Blog][27], [highscalability.com][28] and [Github engineering][29]. You can find a [full list of company blogs here][30].

---- 

That’s all I’ve got to say about practicing for the technical interview. On the third and final part of [the series][31] I’ll talk about the on-site and what happens afterwards (a job offer or rejection).

{% img right-fill /images/signatures/signature8.png 200 ‘My signature’ %} 

_Special thanks to: [@rcruzjo][32], [@patriciob][33], [@pgveiga][34] and [@luketua][35] for helping me edit and improve this series._

[^1]:	At least I was scared at first!

[1]:	https://jivimberg.io/blog/categories/interview-series/
[2]:	https://www.stilldrinking.org/interviewing-is-broken
[3]:	https://hbr.org/2016/04/how-to-take-the-bias-out-of-interviews
[4]:	https://github.com/poteto/hiring-without-whiteboards
[5]:	https://jivimberg.io/blog/2019/01/06/how-to-prepare-for-the-silicon-valley-interview-part-1/
[6]:	https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850
[7]:	http://www.gayle.com/
[8]:	https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850
[9]:	http://www.crackingthecodinginterview.com/contents.html
[10]:	https://smcl.bibliocommons.com/item/show/2387102076
[11]:	https://leetcode.com/
[12]:	https://www.youtube.com/watch?v=J267bz_G7xE
[13]:	https://kotlinlang.org/
[14]:	https://leetcode.com/articles/remove-duplicates-from-sorted-list/
[15]:	https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collectors.html
[16]:	http://www.gayle.com/
[17]:	https://twitter.com/SashaLaundy/status/936661004137635840
[18]:	https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850
[19]:	http://www.crackingthecodinginterview.com/resources.html
[20]:	https://en.wikipedia.org/wiki/Memoization
[21]:	http://www.crackingthecodinginterview.com/uploads/6/5/2/8/6528028/cracking_the_coding_skills_-_v6.pdf
[22]:	https://kotlinlang.org/
[23]:	https://pusher.com/state-of-kotlin
[24]:	https://stackoverflow.com/questions/223918/iterating-through-a-collection-avoiding-concurrentmodificationexception-when-mo
[25]:	https://stackoverflow.com/questions/4818699/practical-uses-for-atomicinteger
[26]:	https://github.com/donnemartin/system-design-primer
[27]:	https://medium.com/netflix-techblog
[28]:	http://highscalability.com/
[29]:	https://githubengineering.com/
[30]:	https://github.com/kilimchoi/engineering-blogs
[31]:	https://jivimberg.io/blog/categories/interview-series/
[32]:	https://twitter.com/rcruzjo
[33]:	https://twitter.com/patriciob
[34]:	https://twitter.com/pgveiga
[35]:	https://www.instagram.com/luketua