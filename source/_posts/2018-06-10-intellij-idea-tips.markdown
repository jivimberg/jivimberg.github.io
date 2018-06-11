---
layout: post
title: "IntelliJ IDEA tips"
date: 2018-06-10 17:11:52 -0700
comments: true
categories: IntelliJ IDEA tips productivity IDE jetbrains
---

Here are a couple of **IntelliJ IDEA** shortcuts and configurations I wish I’d known sooner.

<!--more-->

## 1. Changing the default font

The **first** thing I do every time I have to configure a new installation of IntelliJ is setting the theme to _Darcula_.

[{% img center /images/posts/2018-06-10/Darcula.png 720 ’Darcula theme’ %}][1]

The **second** thing I do is **changing the font** to [Fira Code][2], and **enabling font ligatures.** Here’s how it looks like:

[{% img center /images/posts/2018-06-10/FiraCodeExample.png 720 ’Fira code example’ %}][3]

You can enable this from `Settings` \> `Editor` \> `Font`. Make sure to check `Enable font ligatures` if you like that `≠` symbol.

[{% img center /images/posts/2018-06-10/FiraCode.png 720 ’Fira code setting’ %}][4]

## 2. Auto-reformat

If you’re one of those developers that is obsessively hitting `⌥⇧⌘L`  to get your code reformatted on every keystroke then **I’m about to change your life**. 

First install the **[Save actions][5]** plugin. Now open `Settings` \> `Other settings` \> `Save actions`, in there select: 

* `Activate save actions on save`
* `Reformat file`
* And customize any other inspection and quick fix to your liking

[{% img center /images/posts/2018-06-10/saveActions.png 720 ’Save actions settings’ %}][6]

Now your can just spit your _ugly_ code and **it’ll get perfectly formatted on each save**. _Nice uh?_

## 3. Extend selection

This is not a configuration, but one of my **favorite shortcuts**. I learned this from a [talk][7] by [Hadi Hariri][8]. 

What is it for? Paraphrasing the [IntelliJ blog][9]:

> Structural selection allows you to select expressions based on grammar. By pressing `⌥↑` you keep expanding your selection (starting from the caret). And vice versa, you can shrink it by pressing `⌥↓`.[^1]

Here you can see it in action:

[{% img center /images/posts/2018-06-10/expandSelection.gif ’Expand and shrink selection animation’ %}][10]

Just mentioning this one because it was new to me at the time and nowadays I find myself using it **all the time!**

[^1]:	Had to update the key mappings in the quote because they were old in the original blog post.

[1]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[2]:	https://github.com/tonsky/FiraCode
[3]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[4]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[5]:	https://plugins.jetbrains.com/plugin/7642-save-actions
[6]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[7]:	https://youtu.be/bFcaO1pXzws?t=20m13s
[8]:	https://twitter.com/hhariri?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor
[9]:	https://blog.jetbrains.com/idea/2013/05/30-days-with-intellij-idea-editor-basics/
[10]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/