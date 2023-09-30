---
layout: post
title: "I was trying to sound smart, and now I regret it"
date: 2023-09-22 10:00:27 -0700
comments: true
categories: sociotechnical collaboration
description: Talking difficult might be more harmful than think. This is why you should use jargon with care.
image: /images/posts/2023-09-22/hyrums-law-xkcd.png
---

Maybe it's because I'm an immigrant desperately trying to fit in. Maybe it's one more way of keeping the imposter syndrome at bay. Whatever the reason, I've always been low-key obsessed with software development lingo. I'd go through meetings dropping _principles_ and _laws_ every chance I got. I'd lurk Slack channels waiting for a chance to pounce on a conversation to say "That'd make it worse based on [Brooke's Law](https://en.wikipedia.org/wiki/Brooks%27s_law)" or "You're falling for [confirmation bias](https://en.wikipedia.org/wiki/Confirmation_bias)!". Because I thought that gave me street cred. Same way I'd cover my laptop with stickers to showcase all the frameworks I knew and the conferences I've been to (but only if it was a modern framework and a _"cool"_ conference). Just last week, I [wrote a post](https://jivimberg.io/blog/2023/09/04/the-inverse-conway-maneuver/) teaching an imaginary audience about [Conway's Law](https://en.wikipedia.org/wiki/Conway%27s_law) and posted it on the social network for professional narcissists. 

<!--more-->

But it's not just an egotistical affectation. I honestly believe there are some benefits to knowing these laws and principles by name. Labeling things helps us _think_ about them. I don't fully understand why; I'd need a major in Philosophy to explain this properly, but all I know is Computer Science, so to me, using a name for a complex idea feels like defining a variable. It gives us a handle to refer to it without worrying about the internals. That way, our brains can work with this concept (comparing it, finding applications, counter-examples, etc.) without needing to delve into its definition's nuances every time. Similar to how we can pass around a reference to an object and work with it without caring for its implementation.  

Giving things a name may also help us communicate more efficiently among peers. **We can better use of the communication bandwidth by referring to a complex concept by its name.** It's the difference between saying:

> _"We should be careful about making that change! This service is widely use, so there'll probably be some users relying on such behavior even if we made no promises about it, and it's not documented on the API"_ 
 
and 

> _"Let's be careful and consider [Hyrum's Law](https://www.hyrumslaw.com/)"._ 

{% img center /images/posts/2023-09-22/hyrums-law-xkcd.png 400 %}

Unfortunately, when speaking the words, we cannot include the hyperlink as I did above. **The shortcut only works if both persons known what _"Hyrum's Law"_ means.** It's as they say: "It takes too to dance that ballroom dance originated in Buenos Aires, characterized by marked rhythms and postures and abrupt pauses". You might think this is no big deal. After all, if the listener doesn't know the meaning, they can always interrupt the conversation and ask. But you'd be surprised how rare this is. Admitting to one's ignorance in front of your peers takes a fair amount of courage and trust. The more people in a meeting, the harder it is to ask for clarification. Mention _"Fincher's Law"_ in a hundred person town-hall, and I can guarantee you not one person will ask what it means. Even though they don't know about it because I just made it up. For the following few minutes, half of them will be running Google searches on the side while trying to keep up with the rest of the presentation. The other half was already browsing their Amazon wishlists, half-listening.

 There's an even worse scenario: When both parties know what a term means, but their definitions are not quite the same. The last project I worked on was delayed for a few days because the front-end and back-end engineers (aka me) thought their respective definitions of "upstream service" was the correct one. **There are few things more pernicious to software than uncheck assumptions.**

Another reason to avoid technical jargon is that it contributes to gate-keeping. **Talking difficult might improve communication (providing you avoid the pitfalls mentioned above), but it makes it harder for a newcomer to understand what the hell is going on.** This applies to everything: a new junior developer who just joined the team, the documentation you write for your products, the README file on an open-source project, etc. The more lingo you use, the more people you leave out. 

To sum up, if you're going to use technical jargon or cite a law or principle, make sure that:

1. Your audience understands what you're talking about.
2. Your definition and the audience definition match.
3. You're not talking to (or writing for) newcomers.
4. You're not speaking for a big audience.

{% img right-fill /images/signatures/signature1.png 200 ‘My signature’ %}
