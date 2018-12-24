---
layout: post
title: "Interviewing in Silicon Valley"
date: 2018-12-01 21:27:38 -0800
comments: true
categories: interviewing job silicon valley interview hiring tips
---

For the last few months I’ve been interviewing with different companies on the valley, from some of the well-known giants to promising startups. This is a distilled guide of things I learned in the journey.

<!--more-->

# Process timeline

This is an overview of what the whole process ended up looking in my case:

{% img center /images/posts/2018-12-22/processTimeline.png 750 ‘Process timeline’ %} 

_How much time do you need to go through all of this?_ **Well, it depends**, for me it took a couple of months but YMMV. If you search online you’ll find [plenty of][30] [study plans][1] [to follow][2]. But I think the best thing you can do is to **take it at your own pace**. 

Here are some tips I used to setup my schedule:

* ** Divide the preparation in phases** just like I did on my timeline. Then [Create a new calendar on Google Calendar][3] and use it to **set reminders and deadlines for each of the phases** of the preparation.
* I also used **[Trello][4]** to create a list of tasks to complete. I'd sort them by priority and grab a few to complete each day. The trick is to try to __break them down small enough so that you can complete each of them in one sit__.

{% img center /images/posts/2018-12-22/trello.png 750 ‘Trello screenshot’ %} 

# Where to look for new roles

So you’re ready to move on to greener pastures, _where do you start looking?_

The first obvious answer is **LinkedIn**. Just make your profile as sexy as possible (make sure you [disable notifications if you want to be discrete][5]) and wait for recruiters to start pinging you. 

If you’re looking **for a job at a startup** **[Angel List][6]** is a great place to start. **To learn specifics** about a particular startup head to **[Crunchbase][7]** where you’ll find information about the _funding rounds_ the company has been through, _the investors_, _the team_, etc. 

**If you already have a good sense of what you’re looking for** I can recommend using **[Woo.io][8]**. You'll need to create a profile (you can import most of it from _LinkedIn_) and set your job expectations (role, technologies, company size, location, etc.). **The site will magically find jobs that match your search** and send them to you on a daily basis. You can then review the openings and if they’re not of your liking you can reject them (optionally) including a _reason_ of why it’s not a good fit. **Woo will learn from your feedback and refine the search for future approaches.**

On the other hand, **if you’re unsure about what you want to do next** you can try this trick suggested to me by a friend: Pick a hiring site and skim through the job postings. **Play it by gut**, when something catches your eye **try to reflect on why**. _Was it the technology stack?_ _the company values?_ _maybe the location?_ Don’t worry if you can put your finger on it, **just keep going**. Repeat this enough times and you’ll start getting a sense of what makes you tick.

{% img center /images/posts/2018-12-22/JobSearchFlowDiagram.png ‘Process timeline’ %} 

Trying learn about **the culture of a company** might probe to be a challenge. While most companies include something about culture and values along their job postings, __more often than not is just some generic marketing _lorem ipsum___. Your best alternative is to talk with someone currently working there. **Tech conferences[^1] and Meetups** provide a good opportunity to **talk to engineers and get a first-hand impression of what the culture is like**. Finally, you can fallback to sites like **[Glassdoor][9][^2]** and **[Blind][10]**, just take comments with a grain of salt.

# Updating your resume

Sooner or later you’ll have to sit down and face the dreadful task of updating your resume.

There’s a ton of advice online on how to write a good resume. Instead of trying to sum it all up I’m going to give you **the 3 tips that helped me the most**:

1. **Show your accomplishments.** Your bullet points for each role should focus on your achievements. For example: _"Improved project loading performance on web-app by 5x by introducing hints on
persistence layer to handle transactions more efficiently"_
2. **Don’t include everything.** You’re not writing your autobiography, there’s _no need to include every single task you ever worked on_. Adding extra information only increases the [signal to noise ratio][11]. Trim down your resume to only keep the best of the best. **One or two pages max!**.
3. **Make it look awesome**. _You don’t get a free pass on style just because you’re a developer and not a designer_. Making a pretty resume is going to take you longer, but believe me: recruiters do notice it and appreciate the effort. Going the extra mile will set you apart. For an easy to use graphic-design tool try **[Canva][12]**, __I can’t recommend it enough__.

As an example this is what my resume currently looks like:

[{% img center /images/posts/2018-12-22/resume-1.png 500 ‘My resume page 1’ %} ][resume]

As with any piece of good writing **it’ll take many iterations to get there**. Start with a [shitty first draft][13] and share it with your friends and recruiters to get feedback. 

# Low risk interviews

As with most things in life **you have to try and fail in order to get better**. There is no other way around it.

At first I was terrified about doing interviews. It had been almost 5 years since the last time I interviewed back in Argentina. Fortunately my friend [Luketua][Luketua][^3] was there to give me a great piece of advice: _do low risk interviews_. 

__One of the fastest ways of conquering fear is by JUST DOING the thing you fear__ (the second ride on a rollercoaster is not as scary right?). So take that first step! Pick a company you find interesting, but _it's not your first choice_ and schedule an interview. Even if you _completely_ screw up you will at least have the experience of having gone through it, so the second time won't be as scary. Maybe you'll even learn which topics you need to focus your practice on. Just go for it, __you've got nothing to lose__.

# Programming questions

This is the heart of the technical interview and thus what you’ll spend more time preparing. Some people believe that [_the technical interview model is completely broken_][15]. I don’t really know if [they work or not][16], I just know that **they're part of the game so you better prepare for it**. Having said that, if you are really against _"whiteboard interviews"_ **[check this list][17]** of companies that **don’t rely on this kind of questions**. Just keep in mind that _you might be limiting your options_.

## Cracking the coding interview (6th edition)

**[Cracking the coding interview 6th edition][18]** (CTCI from now onwards) by _[Gayle Laakmann McDowell][19]_ is the _holy bible of interviewing_.

[{% img center /images/posts/2018-12-22/ctci-cover.jpg 300 ‘Cracking the coding interview 6th edition’ %}][18]

I like it because **it is remarkably complete**. It includes a description of the different interview processes at some of the big companies (Apple, Google, Facebook, etc.), it provides tips on how to set up a good resume, it covers the basics on Big O notation and _[much, much more…][20]_

The technical exercises are **organized by topic**. Each chapter includes a **brief introduction** the topic at hand (~3 pages) and a **list of problems** sorted from easy to hard. This is nice because if you don’t have much time or don’t want to focus on a particular area **you can simply skip that chapter altogether**. I, for example, glossed over the _”Java”_ and _”Databases”_ chapters (Chapters 13 and 14 respectively) and skipped the _“C and C++”_ chapter (Chapter 12).

One of the best things about this book is that **each exercise comes with a series of hints you can use in case you get stuck**. I love this because **it mimics what would happen in a real interview**, where the interviewer nudges you in the right direction to unblock you. Also in some of the more complex problems **the book presents multiple solutions and compares the different approaches**. Again, something that would probably come up in a real interview.

**Pro-tip:** If you live in the Bay Area your local library might have [a copy of the CTCI][21]. Having said that, if you have the money this is one of the best investments you can make for your carreer.

## LeetCode

The other thing I used to practice daily was **[LeetCode][22]**. There are a number of sites you can use to practice (here’s a [video comparing the most well-known][23]), I went with LeetCode because it was **explicitly designed for technical interviews** and **it has support for [Kotlin][24]**. 

One thing I like about LeetCode is that it **provides tests results after submission** so you can figure out what you did wrong. Another good feature is that it ranks your submission based on performance so you can see how well you did compared to other solutions.

{% img center /images/posts/2018-12-22/leetcode-submission.png 750 ‘Leetcode submission comparison’ %} 

Where it fells short is in the solution explanation. **Only a small fraction of the problems have [official articles covering the solution][25] and the different approaches it can be solved.** For the rest of them you’ll have to resort to the discussion forum, in the hopes that somebody there posted their answer, and his code is readable.

I **didn’t pay for the premium account** and **didn’t try the _System Design_ questions**, so can’t comment on that.

## Practice tips

### Use a whiteboard

You want your practice to be as close to the real thing as possible. That means you’ll have to **resist the temptation of using your favorite IDE and go full whiteboard**. It will be weird at first. Everything will take more time, you’ll run out of space and _end up using \* and arrows all over the place to add extra variables_. But guess what? **That's is going to happen in the real interview too**. So you better get some practice on whiteboard coding before going in.

Don’t worry, nobody expects you to memorize all [Java Collectors][26]. **It’s OK to ask the interviewer for the details of a particular method signature**.

Having no IDE also **prevents you from writing automated tests for your problems**. Which (_for once_) is a good thing! You won’t have the luxury of unit testing your code during the interview either. Having said that **you should still THINK about the tests you’d write**, and even **whiteboard-debug  some of then** (see below 👇).

### Build the habit

Sometimes you’ll find it hard to sit down and practice. Here are some things that helped me:

1. **Find a time of the day that works for you and stick to it**. For example I’m a morning person. I’d **wake up one hour earlier** each day and practice before breakfast.
2. **Avoid distractions**. Apart from waking up before everyone else **I made sure my phone stayed in airplane mode** at least until I finish one full problem.
3. **Prepare things beforehand**. Before going to bed **I’d set things up so that everything was ready in the morning**. Waking up to a clean whiteboard, the computer charged and [CTCI][19] opened in the right page gives you **less chances to slack or make excuses**.
4. **Set yourself achievable goals**. I found that not finishing my morning practice goal made me anxious during the day. So I figured it was best to set realistic goals, so that **after completing the morning exercise I could feel good about myself for the rest of the day**.
5. **Know when to stop**. Don’t get too caught up on one problem. If you get stuck just drop it for the time being, or move to another exercise. [_”The best debugger ever made is a good night's sleep.”_][27]

## While solving the exercise

### CTCI Cheatsheet

The best advice I could found on how to tackle a problem is from [Cracking the code interview][28]. Luckily they’ve put together this amazing cheat-sheet with a step by step guide:

[{% img center /images/posts/2018-12-22/ctci-cheatsheet-1.png 750 ‘CTCI cheatsheet’ %}][ctci-resources] 

_(It’s also a great example on how  **NOT** to lay out an ordered list of items)_

### Talk through the problem

The whole point of having you solving an exercise during an interview is **to provide the chance for the interviewer to evaluate how you approach a problem**. So the best thing you can do to help your interviewer's job is to **speak through your thought process**.

It'll probably feel odd at first because usually this happens as an internal monologue in your head, so make sure you **practice this even when you’re solving problems on your own**.

Start by **listening to the problem carefully** and **asking clarifying questions** (_does the input fit into memory?_ _how often is this code going to be executed?_ etc.). Then walk your interviewer through each of the steps you take to arrive to the solution. If you’re going to _start by trying and example_ **say it so**, if you’re coming up with a _brute force solution first_ **make that explicit**, if you think the code could be refactored to be more legible **express it**. You’ll get **extra points** for mentioning things, and in some cases you _might be told not to focus on that_, and you’ll benefit from not wasting your time in a detail that was not meaningful to the interviewer.

> **It is ok to be in silence only when you’re thinking**. The rest of the time you should be explaining what you’re doing. **Specially while coding**.

### Problem checklist

There are a list of things you should consider on every problem you face:

* Are you handling nulls properly?
* Have you handled border cases? (empty collections, empty strings, negative integers, etc.)
* Have you considered overflow on arithmetic operations?
* Is the input sorted?
* If it is a collection: can it have duplicates?
* Does the input fit in memory?
* Can a better solution be found or have you achieved the best possible runtime?
* Can you trade space for time?
* Can you precalculate something to speed things up? 
* Is your solution thread safe? If not how can you make it?
* Is there any state you can save to make future runs faster?

### Whiteboard debugging

On [CTCI cheat-sheet][CtciCheat-sheet] step #7 is _Test_. What I like to do for testing my solutinos is what I call _"whiteboard-debugging"_ this is how it goes: 

1. Choose a good input example to work with (not too big, not trivial, not a corner case, etc.). 
2. **Now step through the code step by step** as if you where debugging it.
3. **Use a color marker to write down the variable values as comments** just like your IDE would do. 
 
It should look something like this:

{% img center /images/posts/2018-12-22/isPalindrome.png 600 ‘Whiteboard debugging example’ %}

For this technique to work the only trick is to **suppress your instinct to jump ahead**. With the interviewer watching you'll get anxious and will want to speed things up by skipping a _"trivial loop"_ or just jumping to the result. DON'T DO IT! __Step through the code one line at a time just like the compiler would do__. This is the only way you'll find bugs in your code. 

And of course pay extra attention to hot spots like: __arithmetic expressions__, __null nodes__ and __loop conditions__ (always check for off-by-one errors!).

### Stick to one language

It's no secret that I'm super hooked with [Kotlin][24] (some of my friends would even say I'm a fanboy), so I figured I'd practice the programming questions in Kotlin too. The problem was that Kotlin is not that widespread ([yet][kotlinAdoption]), so __most of my interviews required me to write code in Java__. Kotlin and Java are fairly similar languages and yet I was noticing that writing solutions in Java was taking me longer because of small things like having to look up the exact method I wanted to use. In one of my on-sites, for example, I mixed up the Java `switch` syntax with Kotlin's `when`. And while this isn't a huge mistake, it did raise a valid flag for the interviewer.

__That's why my advice is to pick one mainstream language and stick with it for both: practice and interviews.__

# Open problems

In my experience open problems __are not that common__. When you're presented with one of this questions your main focus should be on clarifying the goal. __Ask as many followup questions as you can and don't make assumptions__ (or if you do validate them with the interviewer). __Don't just jump to the answer!__ Usually this kind of exercises are more about seeing how the candidate approaches the problem rather than getting to the actual solution.

# Language trivia

To my surprise I _did_ find a fair share of language trivia questions. Things like [removing an item while iterating a collection][RemovingAnItemWhileIteratingACollection] or [when to use `AtomicInteger`][WhenToUse`atomicinteger`].

As you can tell this are knowledge base questions, so either you know the answer or you don't. __If you don't just be frank about it__, trying to guess the answer might backfire and make you look like a fraud.

If you're proficient with the language you'll have no problems answering this kind questions. If you want some practice CTCI has one chapter on _Java_ and another one on _C_ and _C++_. 

# System design questions

{% blockquote The System Design Primer %}
The system design interview is an <b>open-ended conversation</b>. You are expected to lead it.
{% endblockquote %}

__The best resource I know to prepare for the System Design interview is [The System Design Primer][TheSystemDesignPrimer]__ (thanks _Pablius_ for the tip!). Additionaly you should __regularly read companies engineering blogs to learn how different challenges are solved in different companies.__ Some of the best ones are: [Netflix Tech Blog][NetflixTechBlog], [highscalability.com][highscalability.com] and [Github engineering][GithubEngineering]. You can find a [full list of company blogs here][FullListOfCompanyBlogsHere].

# Behavioral questions

There are 3 parts to the behavioral questions preparation:

The first thing you should prepare is a __two-minute introduction of yourself.__ __This is your resume condensed to an elevator pitch__. Cover a little bit about _your background_, _your current job responsibilities_ and _any side-project worth mentioning_. If you're curious [this is what my introduction looked like][ThisIsWhatMyIntroductionLookedLike].

Second thing is to prepare the typical interview questions such as: _"Why are you leaving your current job?"_ or _"What are your strengths and weaknesses?"_. 

Finally you should prepare a couple of stories for questions like: _"Tell me about a time you made a mistake"_ or _"Tell me about a time when you had conflicts interacting with one of your coworkers and how you handled it"_. Following the advice in [CTCI][19] I created a table like this:

{% img center /images/posts/2018-12-22/storiesTable.png 750 ‘The on-site routine’ %}

__Pro-tip:__ You can create a document with all of this stuff and use it as a cheat-sheet during your phone call inteviews. Believe me, after a few calls you'll not even need it.

Once again the best advice I came accross for Behavioural questions was from [CTCI][19] and her other book [Cracking the tech career][CrackingTheTechCareer]. You can check Gayle's [Soft Skills Cheatsheet][SoftSkillsCheatsheet] here.

# The on-site routine

This is the routine I came up with for the on-sites:

{% img center /images/posts/2018-12-22/on-siteRoutine.png 750 ‘The on-site routine’ %}

Mindfulness is something I’ve just recently discovered and it’s helping me manage anxiety. I used [Headspace][29] app to do a **15/20 minutes meditation before going in.**

# Your perception is __not__ predictive of performance

This is something I heard first at this [Slilicon Valley Code Camp talk][SliliconValleyCodeCampTalk]. If you start to feel the interview is going south, don't panic! __Just keep going.__ It might be that you were given a hard question, in which case you might not be expected to arrive an optimal solution in the given time (and in any case all other candidates probably struggle through the same question). Or maybe you sense your interviewer is impatient or annoyed. Don't assume it's because of your performance, maybe he's having a bad day or that's just his personality. Point is, __you just don't know__. Here's in Gayle's own words (the whole talk is really worth it):

<div style="text-align: center;">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/8T7a09V1KZo?start=3454" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div> 

Of course I learned this _the hard way_. On one of my on-sites I was struggling with an exercise that looked trivial to me. I ended up arriving to a solution with some help from the interviewer, only to give the wrong answer when asked about the time complexity. To make things worst I was not able to come up with any good improvements to my solution. I was sweating bullets and had to fight the urge of escaping from the interview. Imagine my surprise when, on my way home I received an email saying that I made it to the next step of the process. __Bottomline: You don't know how you're doing. Just keep going.__

# Interviews are a two-way street

One thing to always keep in mind is that interviews are a two-way street: __you're evaluating the company as much as they're evaluating you__. This is your best chance to learn about _the company_, _the role_, _the culture_ and _your future teammates_, son don't miss it! 

This are some of the questions I like to ask: 

* How do you __prioritize__ tasks? How do you __make decisions__? How do you __handle interruptions__? (Ask about hot bugs, devops, CI/CD, etc.)
* What do you __like the most__ about working for this company?
* What's one thing __the team should improve on__?
* What's on the __roadmap__ for the team?

And don't play it safe. __If there's something that is a red flag for your just be direct and ask about it__. After all you're better of knowing things in advance, and you give the interviewer a chance to clarify on the issue. For example __I asked one company why they were using an outdated stack and another one about the recent articles regarding its toxic culture__. As long as you're polite about it nobody is going to get pissed off.

# Rejections

Rejections are just part of the interview process. If you're not being rejected you're probably _not interviewing enough_. The golden rule to handle rejections is: __don't take it personally__. 

The second rule is: __always ask for feedback__. Once I was applying for this startup that made me do a take-home exercise. I spent the best part of my weekend working on it. First I _solved_ the problem, then I _tested_ the code, then I _refactored_ everything nicely into easy to read functions, then I added some more tests and even _documented_ them using [ASCII graphs][AsciiGraphs] (for real). When I sent my submission on Sunday __I was honestly hoping the company would be so impress they would realize there was no need for an on-site__. Two days later I got an email: _"...we have decided to move forward with another candidate..."_ 😢. So with my ego hurt I decided to answer back asking what did I do wrong. __Turns out my code performance sucked!__ In an effort for making the code super readable I had completely destroyed performance. __Needless to say I never made the same mistake again.__

# The follow-up

The obvious thing to do after an interview is to follow-up with a thank you email. Now, __the _smart_ thing to do is to follow-up with questions__. During the interview you'll get a glimpse of what the company is working on, you'll learn about what technologies they use, and how their systems are designed. Naturally you'll have lots of questions that you didn't get to ask during the interview, either because of time constraints or because they didn't occur to you at the time (if you don't then _maybe you're not really that interested in what the company is doing_). __Now is the time to ask!__ Make sure to include them in your follow-up email along with any other comment that comes to mind.

__Pro-tip:__ Use [Google alerts][GoogleAlerts] to set notifications for new content about the company so you'll always know what they're up to. This way I learned that the CEO of one of the companies I was interviewed for was a guest in a podcast and got to ask him about some of the topics he talked about afterwards.

# The offer

This is how a typical offer might be structured:

{% img center /images/posts/2018-12-22/compensation1.png 750 ‘The on-site routine’ %}

To __compare competing offers__ you'll want to get the yearly compensation so:

{% img center /images/posts/2018-12-22/compensation2.png 750 ‘The on-site routine’ %}

If you want to be thorough you should also consider the __vesting period__ as well as financial benefits such as __matching 401k__ and __employee stock option plans__.

Startup offers are trickier to evaluate because of the _risk factor_ involved. __If you're applying for a startup and your offer includes equity I suggest you read [this guide][ThisGuide].__

Finally here's a list of thing you should take into account (other than compensation) when evaluating an offer:

* Who are you going to be working with?
* Do you find the problems challenging and interesting?
* What kinds of things you'll learn at this role?
* What's the company's culture?
* How is the company doing and what's its growth projection?
* How this role will look on your resume?
* How are the offices? And how much is the commute?
* What kinds of benefits and perks does the company offer?

---

# Bonus track: Advice potpurri

* __Smile!__ Try to enjoy the process.
* The interview is not over until the interviewer says so. Until then, keep solving, improving and testing your solution.
* Try to schedule the final round of interviews as close to each other as posible. Some people like to take a week off and do all the on-sites that week.
* You don't have to answer how much you're making in your current job. In some states (CA included) [it's even ilegal to ask][It'sEvenIlegalToAsk].
* __Don't give up after rejection!__ Companies are always let you re-apply after some time. I know a guy that got accepted at Google on his 4th attempt.

---

That's all I have. If you made it down here you deserve a cookie 🍪. Hope you found something useful!

[^1]:	You don’t have to pay full price for the conference if you’re only going to network. Many big conferences offer some kind of _Discovery pass_ that will grant you access to the _Exhibition halls_ where the companies setup their booths.

[^2]:	Pro-tip: If the company is big filter reviews by job title to get a more accurate sense of the culture.

[^3]:   Check his blog: [Codex Transforma](https://www.codextransforma.com/en/decoding-the-inner-truth/decoding-the-inner-truth/)

[1]:	https://www.linkedin.com/pulse/average-googler-four-weeks-study-plan-milad-naseri/
[2]:	https://www.quora.com/Can-I-crack-the-Google-interview-in-just-1-month-of-preparation-If-yes-then-how-I-just-know-the-basics-of-C-and-C++
[3]:	https://support.google.com/calendar/answer/37095?hl=en
[4]:	https://trello.com
[5]:	https://www.dailydot.com/debug/how-to-update-linkedin-without-notifications/
[6]:	https://angel.co/
[7]:	https://www.crunchbase.com
[8]:	https://woo.io/
[9]:	https://www.glassdoor.com/index.htm
[10]:	https://www.teamblind.com/articles/Topics
[11]:	https://en.wikipedia.org/wiki/Signal-to-noise_ratio
[12]:	https://www.canva.com/
[13]:	https://www.goodreads.com/quotes/288933-almost-all-good-writing-begins-with-terrible-first-efforts-you
[15]:	https://www.stilldrinking.org/interviewing-is-broken
[16]:	https://hbr.org/2016/04/how-to-take-the-bias-out-of-interviews
[17]:	https://github.com/poteto/hiring-without-whiteboards
[18]:	https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850
[19]:	http://www.gayle.com/
[20]:	http://www.crackingthecodinginterview.com/contents.html
[21]:	https://smcl.bibliocommons.com/item/show/2387102076
[22]:	https://leetcode.com/
[23]:	https://www.youtube.com/watch?v=J267bz_G7xE
[24]:	https://kotlinlang.org/
[25]:	https://leetcode.com/articles/remove-duplicates-from-sorted-list/
[26]:	https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collectors.html
[27]:	https://twitter.com/SashaLaundy/status/936661004137635840
[28]:	https://www.amazon.com/Cracking-Coding-Interview-Programming-Questions/dp/0984782850
[29]:	https://www.headspace.com/
[30]: https://www.quora.com/How-should-I-prepare-for-my-Google-interview-if-I-have-1-month-left-and-I%E2%80%99m-applying-for-a-software-engineer-role
[31]:   https://kotlinlang.org/
[RemovingAnItemWhileIteratingACollection]: https://stackoverflow.com/questions/223918/iterating-through-a-collection-avoiding-concurrentmodificationexception-when-mo
[WhenToUse`atomicinteger`]: https://stackoverflow.com/questions/4818699/practical-uses-for-atomicinteger
[NetflixTechBlog]: https://medium.com/netflix-techblog
[highscalability.com]: http://highscalability.com/
[GithubEngineering]: https://githubengineering.com/
[FullListOfCompanyBlogsHere]: https://github.com/kilimchoi/engineering-blogs
[TheSystemDesignPrimer]: https://github.com/donnemartin/system-design-primer
[CtciCheat-sheet]: http://www.crackingthecodinginterview.com/uploads/6/5/2/8/6528028/cracking_the_coding_skills_-_v6.pdf
[SoftSkillsCheatsheet]: http://www.crackingthecodinginterview.com/uploads/6/5/2/8/6528028/cracking_the_soft_skills_-_v6.pdf
[SliliconValleyCodeCampTalk]: https://www.youtube.com/watch?v=8T7a09V1KZo
[GoogleAlerts]: https://www.google.com/alerts
[ThisGuide]: https://github.com/jlevy/og-equity-compensation
[It'sEvenIlegalToAsk]: https://www.businessinsider.com/places-where-salary-question-banned-us-2017-10
[resume]: https://drive.google.com/file/d/1M2eVsboWoz76Cv7kD1WtE5UBAkxdnBUV/view?usp=sharing
[Luketua]: https://www.lucasapa.com/
[CodexTransforma]: https://www.codextransforma.com/en/decoding-the-inner-truth/decoding-the-inner-truth/
[ctci-resources]: http://www.crackingthecodinginterview.com/resources.html
[kotlinAdoption]: https://pusher.com/state-of-kotlin
[ThisIsWhatMyIntroductionLookedLike]: https://docs.google.com/document/d/1bX3Vpr9icGCMbJvHMuWb3Q9GmKORf3W2DJ_fziV8Wtk/edit?usp=sharing
[CrackingTheTechCareer]: https://www.amazon.com/Cracking-Tech-Career-Insider-Microsoft-ebook/dp/B00MFPZ9X6
[AsciiGraphs]: http://stable.ascii-flow.appspot.com/#Draw
