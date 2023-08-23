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

{% img center /images/posts/2018-06-10/Darcula.png 720 ’Darcula theme’ %}

The **second** thing I do is **changing the font** to [Fira Code][1], and **enabling font ligatures.** Here’s how it looks like:

{% img center /images/posts/2018-06-10/FiraCodeExample.png 720 ’Fira code example’ %}

You can enable this from `Settings` \> `Editor` \> `Font`. Make sure to check `Enable font ligatures` if you like that `≠` symbol.

{% img center /images/posts/2018-06-10/FiraCode.png 720 ’Fira code setting’ %}

## 2. Auto-reformat

If you’re one of those developers that is obsessively hitting `⌥⇧⌘L`  to get your code reformatted on every keystroke then **I’m about to change your life**. 

First install the **[Save actions][2]** plugin. Now open `Settings` \> `Other settings` \> `Save actions`, in there select: 

* `Activate save actions on save`
* `Reformat file`
* And customize any other inspection and quick fix to your liking

{% img center /images/posts/2018-06-10/saveActions.png 720 ’Save actions settings’ %}

Now your can just spit your _ugly_ code and **it’ll get perfectly formatted on each save**. _Nice uh?_

## 3. Extend selection

This is not a configuration, but one of my **favorite shortcuts**. I learned this from a [talk][3] by [Hadi Hariri][4]. 

What is it for? Paraphrasing the [IntelliJ blog][5]:

> Structural selection allows you to select expressions based on grammar. By pressing `⌥↑` you keep expanding your selection (starting from the caret). And vice versa, you can shrink it by pressing `⌥↓`.[^1]

Here you can see it in action:

{% img center /images/posts/2018-06-10/expandSelection.gif ’Expand and shrink selection animation’ %}

Just mentioning this one because it was new to me at the time and nowadays I find myself using it **all the time!**

## Have any IntelliJ tip to share? I’d love to know about it! **Post a comment** down here 👇

[^1]:	Had to update the key mappings in the quote because they were old in the original blog post.

[1]:	https://github.com/tonsky/FiraCode
[2]:	https://plugins.jetbrains.com/plugin/7642-save-actions
[3]:	https://youtu.be/bFcaO1pXzws?t=20m13s
[4]:	https://twitter.com/hhariri?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor
[5]:	https://blog.jetbrains.com/idea/2013/05/30-days-with-intellij-idea-editor-basics/