---
layout: post
title: "Random thoughts on using Gradle with Kotlin DSL"
date: 2018-08-28 08:36:57 -0700
comments: true
categories: gradle kotlin kotlin-dsl multi-module spring
---

Since Gradle 3.0 you can [**write your build scripts using Kotlin instead of Groovy**][1]. I was curious, so I decided to give it a try. Here are my thoughts on the process.

<!--more-->


# Why?

Ok, we can write our build scripts in Kotlin, but you might be wondering: _”why would I want to do that?”_ Here are my reasons:

## 1. All things Kotlin

Our backend codebase is _mostly written in Kotlin_. We even wrote our [githooks using Kotlin scripts!][2] So it was only natural to use Kotlin on our build tools too. 

Being able to use the same language across the stack means that your learning efforts pays double. This way **the team doesn’t have to learn a new language just to write a simple Gradle task.** And as an added bonus you can apply _the same testing, coverage and code inspection tools_ that you use in production to your tooling code.

## 2. IDE support

The second reason for making the transition was IDE support. Groovy is a dynamically typed language, which makes it harder for the IDE to provide accurate code completion and script validity through type checks. Kotlin being statically typed doesn’t suffer from the same problems

{% img center /images/posts/2018-09-11/kotlin-code-completion.png ‘Kotlin code completion’ %} 

## 3. Interoperability

As you probably know [Kotlin was designed with Java interoperability in mind][3]. And the same interoperability [extends to Groovy code]().

This interoperability let us **[call Groovy code from Kotlin][5] and [viceversa][6]**. Which effectively means that you can have **a mix of both Groovy and Kotlin scripts working together in the same project**. So no need to migrate all your build scripts at once, or to push stubborn _“Wally”_ to learn Kotlin DSL.

{% img center /images/posts/2018-09-11/wally2.png ‘Wally’ %} 

# The exodus

_”So how painful was the migration?”_ It wasn’t that bad really. Kotlin DSL was designed to be pretty similar to the classic `build.gradle` files. 

You’ll just have to **push through that first moment** when nothing seems to be working, your project doesn’t compile at all, and you know you’re a `⌘ + Z` away from a pristine working copy. _But you can't make an omelet without breaking a few eggs, can you?_

{% img center /images/posts/2018-09-11/panic.png ‘Panic!’ %} 

**I just wish there was some kind of automatic migration action in IntelliJ.** Even if it’s a best effort that leaves you half way there, I’d greatly appreciate it. Ideally it should work just like when you paste some Java code into a Kotlin file: `⌘ + V` + ✨_fairy dust_✨ and you have your `build.gradle.kts` ready to go.

### Resources

This are the resources that help me complete the migration. Hopefully you’ll find them helpful too.

* [**Official Gradle migration guide**][7] **Start here!** You don’t have to cover the whole thing but you can skim through it and later go back to the section you need.
* [**Samples in the Kotlin DSL repo**][8] This is **the go-to place for Kotlin DSL samples**. You’ll find yourself coming back to this repo over and over. Be sure to search the _Issues_ section too.
* For the times when the [Kotlin DSL repo][9] doesn’t have what you’re looking for, I find it useful to use [**Github Search**][10] looking for code in files with `*.kts` extension.
* [**jnizet/gradle-kotlin-dsl-migration-guide**][11] this is another migration guide that has proven useful in the past.
* Finally I followed [**this article**][12] by [Handstand Sam][13] to do _dependency management_ on out multi-module project.

# The not so good

## 1. _“I can’t just copy-past things from Stack Overflow”_

{% img center /images/posts/2018-09-11/copy-paste.jpg 250 ‘Copy paste from Stack Overflow’ %} 

This is **by far the biggest drawback**. In my experience most teams have one or two _”build tool experts”_. The rest of the team just use a few tasks and maybe add a dependency every now and then. This casual user might have a harder time using Kotlin DSL because **copy-pasting pieces of code from the web will not work out of the box**. Converting this snippets to Kotlin DSL is not rocket-science, but in some cases it might require some basic level of understanding of how Kotlin DSL works.

This is specially true when using plugins that were not designed with Kotlin DSL in mind (I’m looking at you [protobuf Gradle plugin][14]).

## 2. IDE support could be better

Remember all the nice things I said about IDE auto-completion on the build scripts? Well let me clarify: _“IDE support is awesome… most of the time”_.

Once you have your script fully migrated and IntelliJ has finished indexing then everything should work just fine. But to get there you’ll have to have your full `build.gradle` script fully migrated. That’s why my advice is to **comment everything out and start migrating piece by piece**. For example you can start with configuring the _repositories_, and _plugins_ and only then move to _dependencies_.

This gets intensified if you are working on a [multi-module project][15] and/or you’re using [`buildSrc` for custom plugins][16].

The silver lining is that IDE support is getting better with each release, and once you’ve migrated everything it mostly works.


[1]:	https://blog.gradle.org/kotlin-meets-gradle
[2]:	https://jivimberg.io/blog/2018/07/03/writing-githooks-in-kotlin/
[3]:	https://kotlinlang.org/docs/reference/java-interop.html
[5]:	https://guides.gradle.org/migrating-build-logic-from-groovy-to-kotlin/#calling_kotlin_from_groovy_2
[6]:	https://guides.gradle.org/migrating-build-logic-from-groovy-to-kotlin/#calling_kotlin_from_groovy
[7]:	https://guides.gradle.org/migrating-build-logic-from-groovy-to-kotlin/
[8]:	https://github.com/gradle/kotlin-dsl/tree/master/samples/
[9]:	https://github.com/gradle/kotlin-dsl/tree/master/samples/
[10]:	https://github.com/search/advanced
[11]:	https://github.com/jnizet/gradle-kotlin-dsl-migration-guide
[12]:	https://handstandsam.com/2018/02/11/kotlin-buildsrc-for-better-gradle-dependency-management/
[13]:	https://handstandsam.com/about-me/
[14]:	https://github.com/google/protobuf-gradle-plugin/issues/219
[15]:	https://guides.gradle.org/creating-multi-project-builds/
[16]:	https://docs.gradle.org/current/userguide/custom_plugins.html