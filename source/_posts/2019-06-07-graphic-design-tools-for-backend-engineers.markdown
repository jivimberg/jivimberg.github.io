---
layout: post
title: "Graphic design tools for backend engineers"
date: 2019-06-07 22:14:38 -0700
comments: true
categories: graphic design tools productivity communication draw graphs visual soft-skill
---

You might think that being a backend engineer means you’ll never have to draw anything more complex than a bunch of boxes connected with arrows (or hexagons if are going all cloud native). This is simply not true, and that’s why you’re here. 

At some point you’ll find yourself producing system diagrams, flow-charts, slides, mockups, maybe even icons! So, let me show you some tools and tricks I picked up over the years to fake it at design.

<!--more-->

## Hand-draw images

Maybe you noticed that some of the drawings that I use on this website look like they where done by a 5 year old. Like this one:

[{% img center /images/posts/2019-06-18/consumerDiagram.png  800 ‘A hand drawing’ %}][1]

I create these using [Microsoft’s OneNote][2] on my wife’s [Surface Pro][3]. The app it’s somewhat basic, but it does one key thing: it lets you select your traces, move them around and scale them with simple gestures. And that’s really alI you need.

{% img center /images/posts/2019-06-18/surfacePro.jpg  600 ‘Drawing on a SurfacePro’ %}

Also you can drop any kind of file to OneDrop and draw on top of it. 

{% img center /images/posts/2019-06-18/meFramed.png  200 ‘A doodle on my face’ %}

But, as I said, the Surface Pro is not mine, so I don’t get to take it to work. At the office I use a low-tech alternative: a **[Rocketbook][4]**. It’s a notebook you can erase with water. 

{% img center /images/posts/2019-06-18/rocketbook.gif ‘Rocketbook animation’ %}

The pages are from a plasticky material, but it feels pretty close to drawing on actual paper. And you get karma points for not needing dead trees to do your half-ass doodles.

The best thing is that it comes with an app that allows you to scan your drawings and configure an action based on an icon you mark on the page. This helps me digitalize all my notes in a breeze. I can sketch something quickly, take out my phone and share it in Slack in 2 seconds, and without having to shell out $1k for an iPad.

{% img center /images/posts/2019-06-18/slack.png ‘Slack conversation with drawing’ %} 

My only complain is that you have to wait a couple of minutes for the pages to dry when you’re cleaning it. So cleaning the whole book might take you 15 or 20 minutes. But I only do this once a month so it’s not that big of a deal for me.

## System diagrams and Flowcharts

Let’s face it, most of your diagrams will still be boxes, cylinders and stick-figures. You don’t want your wiki page or slides including an image like this:

{% img center /images/posts/2019-06-18/ugly-whiteboard.png  400 ‘Whiteboard image that looks ugly’ %}

Why not do it with style? Meet **[Whimsical][5]**. With this tool you’ll be able to spit beautiful diagrams in seconds. It’s deceptively simple. It has smart snap to grip and auto-grouping that at times feels like it’s reading your mind.

{% img center /images/posts/2019-06-18/whimsical.gif 800 ‘Whimsical demo’ %}

It can do flowcharts, mind maps, wireframes and sticky notes. The catch is you only get 4 _“boards”_ for free. After that it’s $10 a month💰

If you don’t feel like paying you can always use [draw.io][6]. It has Google Drive integration, and a wide variety of shapes for different types of diagrams (Flow-chars, UML, BPMN, etc).

Use the comic style to get your diagrams to look like this:

[{% img center /images/posts/2019-06-18/drawio.png  ‘Draw.io example’ %} ][7]

_(This diagram is from my [“Writing Githooks in Kotlin”][8] post)_

If all you’re trying to create is a UML of your existing code then you should check [this Intellij feature][9] that gives you just that in a couple clicks.

{% img center /images/posts/2019-06-18/intellijUML.png 600 ‘UML diagram from Intellij’ %}

Similarly if you’re using Spring you can [get a beans dependencies diagram][10] just as easily.

{% img center /images/posts/2019-06-18/beans-dependencies.png 600 ‘Beans dependencies diagram on Intellij’ %}

## Sharing snippets of code

If you need to share a snippet of code you can create a Gist like this one: [sendForm.gs][11]. And you can easily embed them in a page:

{% gist 8cae46cdb5b98c0d19176efcde2eadd9 %}

Gist are great because they have version history, can be commented, forked and starred and you can group multiple files in a single Gist.

If you happen to be working with Kotlin you can also use [Kotlin Playground][12], this way you also get the ability to execute the code. Here is [an example][13]. You can also embed them as well, or better yet, [include Kotlin playground as a script in your page][14] and have all your code blocks converted to runnable snippets.

<xmp class="kotlin-code" theme="darcula">
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.FlowPreview
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.channels.consumeEach
import kotlinx.coroutines.channels.produce
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.asFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.launch
import kotlin.system.measureTimeMillis

//sampleStart
@ExperimentalCoroutinesApi
@UseExperimental(FlowPreview::class)
suspend fun main() {
    val time = measureTimeMillis {
        (1..10).asFlow()
            .parallelMap(3, 3) { delay(100); it * 2 }
            .collect { print("$it ") }
    }
    println()
    println("Execution time in millis: $time")
}
//sampleEnd

@kotlinx.coroutines.FlowPreview
@kotlinx.coroutines.ExperimentalCoroutinesApi
fun <T, R> Flow<T>.parallelMap(
    bufferSize: Int,
    concurrency: Int,
    transform: suspend (value: T) -> R
): Flow<R> {
    require(bufferSize >= 0) { "Expected non-negative buffer size, but had $bufferSize" }
    require(concurrency > 0) { "Expected concurrency level greater than 0, but had $concurrency" }

    return flow {
        coroutineScope {
            val inputChannel = produce {
                collect { send(it) }
                close()
            }

            val outputChannel = Channel<R>(capacity = bufferSize)

            // Launch $concurrency workers that consume from
            // input channel (fan-out) and publish to output channel (fan-in)
            val workers = (1..concurrency).map {
                launch {
                    for (item in inputChannel) {
                        outputChannel.send(transform(item))
                    }
                }
            }

            // Wait for all workers to finish and close the output channel
            launch {
                workers.forEach { it.join() }
                outputChannel.close()
            }

            // consume from output channel and emit
            outputChannel.consumeEach { emit(it) }
        }
    }
}
</xmp>

Finally, if all you want is to show some highlighted code you can use [carbon.sh][15] to get a beautiful image of your source code, like this one:

{% img center /images/posts/2019-06-18/carbon.png  ‘Carbon.sh demo’ %}

## Presentations

I’ve used a lot of [**Prezis**][16] in the past. If you’ve never seen a Prezi think a giant canvas where you drop stuff, and each slide is basically zooming to a different portion of the canvas. Here’s an example of a Prezi I did about the things I learned from [Coursera’s gamification course][17] by [Kevin Werbach][18].

<iframe id="iframe_container" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen="" allow="autoplay; fullscreen" width="550" height="400" src="https://prezi.com/embed/uyg0exmhwbrn/?bgcolor=ffffff&amp;lock_to_path=0&amp;autoplay=0&amp;autohide_ctrls=0&amp;landing_data=bHVZZmNaNDBIWnNjdEVENDRhZDFNZGNIUE43MHdLNWpsdFJLb2ZHanI5dkNTakxDRmJwb3czakswMFhxZHJkNGtRPT0&amp;landing_sign=YH6jqN1LpGyTSh-ze0MNsqdGvDrfivc-HRxIPrpG7H8"></iframe>

It’s an awesome tool that adds a world of possibilities to your presentations. But, with time I understood that just throwing cool transitions doesn’t make your presentation that much better. As any good designer knows, [animations need to serve a purpose][19]. Prezi works best when you use its zooming effects to reinforce the ideas you’re trying to communicate, or to use the canvas layout so that viewers get a good sense on how the content is organized. If you combine this tools in a meaningful way you can create amazing presentations [like this one][20].

This days, though, if I need to throw a deck together quickly, I hit [**Slides Carnivals**][21]. I pick a template that matches the topic I’m covering, import it in Google Slides and start working on it. Only if I need some fancy animations I’d use Keynote (see next topic).

{% img center /images/posts/2019-06-18/slidesCarnival.png 800  ‘Slides carnival’ %}

Finally,  it doesn’t really matter which tools you use if you’re just going to cramp 3 paragraphs of text in a slide. And no, having bullet points doesn’t make it any better.  You need to [give your deck some ❤️][22]. But  that’s a topic for another day.

## Animations

Animations can be super useful to visualize complex concepts. Specially on the backend world where much of our work consists of translating the mental model we have of the system into code. Creating visual cues, like animations, helps us communicate our intent in an unambiguous way.

Don’t believe me? Try explaining how the [different kinds of Kotlin channels][23] behave using just words. Then check this animation:

{% img center /images/posts/2019-04-18/Channels.gif  600 ‘Channels animation’ %}

You can create simple animations like this one 👆 on **[Keynote][24]**. Using _Magic move_ and playing around with the order you can create all kind of choreographed animations. When you’re satisfied with the result, [you can export your creation as a gif][25] and share it with the world.

## UI Mocks

If you ever worked with non-tech people you know the importance of showing something. Just telling them about what a system will do or how it would look it’s not enough. They have to see it 👀. That’s why low-res mockups are so powerful. You can use a tool like [Balsamiq][26] to create something like this in minutes. And you can even make them interactive to show how different screens would connect to each other.

{% img center /images/posts/2019-06-18/balsamiq.png 600 ‘balsamic example’ %}

Whimsical also has wire-framing capabilities: 

{% img center /images/posts/2019-06-18/whimsical-wireframe.png ‘Whimsical wireframe’ %}

If you’re looking for something more high-res checkout [InVision][27], that’s what all the cool kids are using this days.

## Logos, banners and more

**[Canva][28]** is probably the **best design tools for non-designers** you’ll find online, hands down.  I’ve used it for all kind of things. I’ve used it to create logos:

{% img center /images/posts/2019-06-18/Kassette.png 250 ‘Logo created in Canva’ %}

Presentations:

[{% img left /images/posts/2019-06-18/Stability.jpg 225 'Stability' %} ][29]

[{% img left /images/posts/2019-06-18/MinimizeAccessibility.jpg 225 'Minimize Accessibility' %}  ][30]

[{% img /images/posts/2019-06-18/ImplVsInterface.jpg 225 'Implementation Vs Interface' %} ][31]

My resume:

[{% img center /images/posts/2019-06-18/resume-1.png  500 ‘My Resume’ %}][32]

Banners for [an Android app I wrote][33]:

[{% img center /images/posts/2019-06-18/PracticePronunciation.png 400 ‘Practice pronunciation banner’ %}][34]

And much, much more… Seriously, if you’ve never used it just go and check it out because it’s amazing, and super simple to use.

## Icons

Check out the [Icon generator][35], part of the [Android Asset Studio][36] tools put together by [@Romanurik][37]. Specially if you’re doing something on Android. 

## Bonus tips

**Tip 1:** Searching Google Images for some fancy image to drop into your diagram? Add `filetype:png` to your search to filter for PNG images. Also, make use the search tools to filter by color, size and license type!

**Tip 2:** **`⌘ + Shift + 5`**. Screenshot everything. Screenshot your code in the IDE, screenshot multiple frames from a video and turn it into a gif, screenshot your drawings when the app you’re using doesn’t export to image ([I’m looking at you OneNote][38]). For example, for this post I wanted to create the photo border effect on my picture up there 👆. I knew Keynote had such effect but it’s not meant for image editing. So what did I do? I created a new slide with white background, drop my image, added the desired effect, _⌘ + Shift + 5 _, and voila! I know it’s hacky, but it gets the work done!

**Tip 3:** Befriend graphic designers. Ask them what tools they use. Watch them work. Take note on how they dress.

 {% img right-fill /images/signatures/signature2.png 200 ‘My signature’ %} 

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[1]:	https://jivimberg.io/blog/2019/02/23/sqs-consumer-using-kotlin-coroutines/
[2]:	https://products.office.com/en-us/onenote/digital-note-taking-app
[3]:	https://www.microsoft.com/en-us/p/surface-pro-5th-gen/8nkt9wttrbjk?activetab=pivot:overviewtab
[4]:	https://getrocketbook.com/
[5]:	https://whimsical.com
[6]:	https://www.draw.io/
[7]:	https://jivimberg.io/blog/2018/07/03/writing-githooks-in-kotlin/
[8]:	https://jivimberg.io/blog/2018/07/03/writing-githooks-in-kotlin/
[9]:	https://www.jetbrains.com/help/idea/class-diagram.html
[10]:	https://www.jetbrains.com/help/idea/spring-support.html
[11]:	https://gist.github.com/jivimberg/8cae46cdb5b98c0d19176efcde2eadd9
[12]:	https://play.kotlinlang.org/
[13]:	https://pl.kotl.in/_h-DbUrtj
[14]:	https://blog.jetbrains.com/kotlin/2018/04/embedding-kotlin-playground/
[15]:	https://carbon.now.sh
[16]:	https://prezi.com
[17]:	https://www.coursera.org/learn/gamification
[18]:	https://www.coursera.org/instructor/~226710
[19]:	https://material.io/design/motion/#principles
[20]:	https://prezi.com/mgujrvianlqb/virtual-tour-ceva-logistics/
[21]:	https://www.slidescarnival.com/
[22]:	https://zachholman.com/posts/slide-design-for-developers/
[23]:	https://kotlin.github.io/kotlinx.coroutines/kotlinx-coroutines-core/kotlinx.coroutines.channels/index.html
[24]:	https://www.apple.com/keynote/
[25]:	https://support.apple.com/kb/PH28038?locale=en_US&viewlocale=en_US
[26]:	https://balsamiq.com/
[27]:	https://www.invisionapp.com
[28]:	https://www.canva.com
[29]:	https://jivimberg.io/blog/2014/10/12/notes-on-api-design/
[30]:	https://jivimberg.io/blog/2014/10/12/notes-on-api-design/
[31]:	https://jivimberg.io/blog/2014/10/12/notes-on-api-design/
[32]:	https://drive.google.com/file/d/12FKryxTfewr_QtvQtTDMJf-NwmuySY2k/view
[33]:	https://play.google.com/store/apps/details?id=com.eightblocksaway.android.practicepronunciation&hl=en_US
[34]:	https://play.google.com/store/apps/details?id=com.eightblocksaway.android.practicepronunciation&hl=en_US
[35]:	https://romannurik.github.io/AndroidAssetStudio/icons-generic.html
[36]:	https://romannurik.github.io/AndroidAssetStudio/index.html
[37]:	https://roman.nurik.net/
[38]:	https://answers.microsoft.com/en-us/office/forum/office_2013_release-onenote/how-do-i-export-a-onenote-2013-page-as-an-image/825a08e3-f6c4-4d14-9e3e-c1ec54eb7b99?auth=1