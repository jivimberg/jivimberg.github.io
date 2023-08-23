---
layout: post
title: "How platform teams get shit done"
date: 2023-07-28 00:43:59 -0300
comments: true
categories: platform migrations collaboration
description: Visual summary of the different collaboration patterns between product and platform teams.
image: /images/posts/2023-07-28/how-platform-teams.png
---

[Pete Hodgson][1] explored the different ways in which a Platform team works with other teams to get shit done in [this article][2]. I thought it was interesting to see how collaboration changes based on the type of work, so I put together this visual summary to compare and contrast each type of interaction.

<!--more-->

[{% img center /images/posts/2023-07-28/how-platform-teams.png 600%}][3]
<em class="img-caption">Click image to enlarge</em>

I added a few things here and there, but most of the stuff is taken from the [original article][4], so if you care about this topic I recommend you check it out!

I found particularly interesting the realization that migrations are hard because **the team that owns the code that needs changing is not the one driving the migration.** This creates a situation of misaligned incentives and makes it a socio-technical problem. The article describes the different ways the teams can collaborate to get it done, but it’s also important to understand the tools a platform team has to remove this friction in the first place, things like [sidecars][5], [meshes][6] and [service chasis][7].

I also included a section on how Google does Large-Scale Changes (LSC). They created a tool that allows anybody to submit Large-Scale Changes that are applied across the whole codebase. They advocate for the approach of centralizing the migration, to the point where most changes are reviewed by a single expert, and local teams hold no veto power over the LSC. They rely on code analysis and transformation tools to write the LSC and have a test infrastructure to automatically run all tests that a given change might affect in an efficient manner. To read more about their approach refer to [Software Engineering at Google][8] Chapter 14.

{% img right-fill /images/signatures/signature7.png 200 ‘My signature’ %}

[1]:	https://thepete.net/
[2]:	https://martinfowler.com/articles/platform-teams-stuff-done.html
[3]:	/images/posts/2023-07-28/how-platform-teams.png
[4]:	https://martinfowler.com/articles/platform-teams-stuff-done.html
[5]:	https://medium.com/nerd-for-tech/microservice-design-pattern-sidecar-sidekick-pattern-dbcea9bed783
[6]:	https://konghq.com/learning-center/service-mesh/what-is-a-service-mesh#:~:text=Service%20mesh%20is%20a%20technology,it%20can%20be%20managed%20independently.
[7]:	https://blog.thepete.net/blog/2020/09/25/service-templates-service-chassis/
[8]:	https://www.amazon.com/Software-Engineering-Google-Lessons-Programming/dp/1492082791