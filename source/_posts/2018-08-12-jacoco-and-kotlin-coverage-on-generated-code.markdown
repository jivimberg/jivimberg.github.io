---
layout: post
title: "JaCoCo &amp; Kotlin: coverage on generated code"
date: 2018-08-12 21:26:43 -0700
comments: true
categories: JaCoCo Kotlin coverage generated
---

JaCoCo works _flawlessly_ with Kotlin. Except when it reports lines not covered on generated code 😡. Fortunately there’s a fix already in place.

<!--more-->

{% img center /images/posts/2018-08-12/JaCoCo-before.png 720 ’JaCoCo before’ %}

{% blockquote Me, Every time I saw the coverage report %}
What!? I didn’t even write those functions! There’s no way I’m writing tests for them. I’m pretty sure the compiler knows what it’s doing…
{% endblockquote %}

Good news is that this [has been fixed][1] in the latest JaCoCo release (thanks to [goodwink][2]). Bad news is that **0.8.2 is not out yet** 😞

If you are like me, and can’t wait to get this working, you can **use the SNAPSHOT version of JaCoCo** making this changes on your `build.gradle`:

{% codeblock lang:kotlin %}
repositories {
	…
	maven("https://oss.sonatype.org/content/repositories/snapshots")
}

jacoco {
	toolVersion = "0.8.2-SNAPSHOT"
}

{% endcodeblock %}

_(I’m using [Gradle with Kotlin DSL][3] in this example)_

Now you can finally take your Kotlin coverage to 100% without having to write tests for `component1()` and `component2()`.

{% img center /images/posts/2018-08-12/JaCoCo-after.png 720 ’JaCoCo after’ %}

[1]:	https://github.com/goodwinnk
[2]:	https://github.com/goodwinnk
[3]:	https://github.com/gradle/kotlin-dsl