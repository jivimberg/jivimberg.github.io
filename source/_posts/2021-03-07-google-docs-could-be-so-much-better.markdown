---
layout: post
title: "Google Docs could be so much better!"
date: 2021-03-07 18:50:06 -0800
comments: true
categories: 
---

Lots of businesses run on Google Docs. It's how we write memos, define strategies, discuss proposals, document decisions, write tutorials, and plenty of other things.

Google Docs is a fantastic piece of technology. I almost can't imagine how we worked before it (_productStrategy-Jun-2004-version13.docx_ anyone?). And yet, I sometimes feel like it could be so much more! Like we'll look back in 10 years and think: _“My god! I can’t believe we were working that way!”_. Improving Docs has the potential of completely overhauling the way information flows through an organization. Here are some ideas on how Google could improve it.

<!--more-->

##  Smart Summaries

It’s early in the morning, and you’re checking your emails. You notice your boss shared the new strategy memo. You still have 15’ minutes to your next meeting, so you think: _“I’ll catch up on this one real quick”_. You start reading and, in the first paragraph, you found a reference to another doc you were not aware of. So you open the link on a new tab and keep going. As you tread through the doc, you find more and more links to review. Before you know your browser looks like this:

{% img center /images/posts/2021-03-29/tabs.png 700 %}

What you thought would take five minutes ends up being an endeavor that takes you the whole morning. 

There’s probably no good way around this problem if you need to absorb every detail. But more often than not, all you need is a high level overview of the referenced content. The further away you move from your starting doc, the less detail you probably want. 

Wouldn’t it be nice if Docs could automagically generate that summary by using a bit of AI? We could read the auto-generated summary and decide if we need to go deeper down the rabbit hole. The experience would be similar to the [Link Preview feature][1] released in 2020.

{% img center /images/posts/2021-03-29/link-preview.gif %}

## Discovery and Navigation

Google Docs favors a filesystem-like organization. You can sort your docs into folders and browse them in a tree view, just like you would navigate files on your local machine.

{% img center /images/posts/2021-03-29/folders.png 200 %} 

It’s a well-known pattern that we are all familiar with, and it works great when there’s a centralized authority dictating how things are supposed to be organized. But that’s not how knowledge works. Our brain likes to connect thoughts and ideas in the most unintuitive ways, making connections that at first would look random. Some note-taking apps recognized this need and built experiences around the concept of navigating documents based on how they relate to each other. If the idea sounds strange, just think about how web pages work by links that point to other pages. Imagine if we could capture this relationship **on both ends, and list all outgoing and incoming connections**. This is exactly how [Collected Notes][2] works.

{% img center /images/posts/2021-03-29/collected-notes.jpeg 650 %} 

This paradigm lets us navigate the relationship in both directions! Let’s say we wrote a thoughtful memo on [”why we should stop asking people to invert a binary tree as part of the interview process”][3]. People seemed to like it and start sharing it around. Soon it gains traction, and everybody in the company is talking about it. With bi-directional links, we’d be able to see how our ideas are referenced on other documents. We can keep an eye on any proposals (or refutals) that are inspired by the original post.

From these links, we could create new visualizations to represent how documents relate to each other. This can help us identify the most popular docs at a glance and discover patterns like high-level strategy docs linked by more specific implementation docs. [Roam Research][4] has a view called [“Graph Overview”][5] to serve this purpose. Each dot represents a note, and each line is a reference. The bigger the dot, the more connections it has.

{% img center /images/posts/2021-03-29/roam.png 500 %} 

## Consuming content

We all know Google Docs is an _amazing_ tool for producing content. For consuming it? Not so much 😒👎🏼 Yet the time we spend reading documents is far greater than the time we spend writing them. Improving the reading experience would make everybody a more effective collaborator.

{% blockquote Kurt Lewin %}

 Learning is more effective when it is an active rather than a passive process.

{% endblockquote %}

To comprehend something more easily, we need to work with the content. We need to highlight important parts, scratch things out, scribble notes and comments on the margins, etc. In other words, we need to pour our ideas on the doc and make it our own. My favorite app to do this kind of interactive reading is [LiquidText][6], it works especially well on an iPad with the Apple Pencil.  I use it to read docs, articles, papers, and sometimes even books.

{% img center /images/posts/2021-03-29/liquid-text.jpeg 700 %} 

Imagine if we could get a similar experience _within_ Google Docs. What if we could have a private view of the doc where we’d be able to mark it and comment it to our heart’s content. Of course, you can get halfway there today by copying the doc before reading it, but that’d totally break the collaborative features since the copy will never get the updates/comments the original will receive.

The fact that these notes would be private doesn’t mean that we can’t mine them for insight. It’d be pretty easy to leverage the private highlights to power the AI summary mentioned above, or to provide an auto-highlighting feature alla Kindle.

{% img center /images/posts/2021-03-29/highlight.jpeg 500 %} 

---- 

What do you think? Do these features sound helpful to you? I’d love to hear _your ideas_ on how to improve Docs. Drop me a comment below  👇

 {% img right-fill /images/signatures/signature6.png 200 ‘My signature’ %} 

[1]:	https://www.youtube.com/watch?v=AAeloLXO8T0
[2]:	https://collectednotes.com/blog/zettelkasten
[3]:	https://jivimberg.io/blog/2020/05/09/the-whiteboard-interview-is-broken/
[4]:	https://roamresearch.com/
[5]:	https://roamresearch.com/#/app/help/graph
[6]:	https://www.liquidtext.net/