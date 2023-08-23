---
layout: post
title: "Using Docker for development"
date: 2019-01-02 17:27:34 -0800
comments: true
categories: docker development dependencies
---

Docker has transformed the way we package and ship applications. But. did you know it can transform your development setup too?

<!--more-->

{% img center /images/posts/2019-01-02/docker-party.png ‘Docker party’ %} 

Stop me if you've heard this one before: _You get a new computer. As you're setting it up, you swear on Turing's grave, to only install the bare essentials on it and avoid bloatware at all costs. Fastforward a couple of months, you have the Java JDK, Go tools, multiple versions of Python and the Android SDK (for that [side-project app][Side-projectApp] you might someday resume developing) installed on your machine._

## Docker to the rescue

That's right, you can use Docker to containerize your development environment! This way you avoid installing all that tooling on your host machine, making Docker your only dependency. __Now you can develop from any computer, regardless of the OS, as long as it has Docker installed__. As an extra benefit, all collaborators of the project get consistent environments, so, no more: _"works on my machine"_.

I discovered this fighting to setup the env to write this blog on a new machine. After playing _"google the exception"_ for a few hours I though: _there has to be a better way of doing this_. Using [this repo][ThisRepo] as inspiration I added a `Dockerfile` to my project, that creates a Docker image containing all the dependencies needed to run [Octopress][Octopress]. Then simply by mounting the project directory on the `/octopress` folder I can run all the [usual `rake` tasks][Usual`rake`Tasks], just as I'd do locally, but on the container.

No more messing around with language environments and dependencies. Build the image, spin up a container, and blog from anywhere.

[ThisRepo]: https://github.com/humburg/octopress-docker
[Octopress]: http://octopress.org/
[Usual`rake`Tasks]: http://octopress.org/docs/blogging/
[Side-projectApp]: https://play.google.com/store/apps/details?id=com.eightblocksaway.android.practicepronunciation
