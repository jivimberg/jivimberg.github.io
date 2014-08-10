---
layout: post
title: "Android animations are just a trick"
date: 2014-08-10 12:44:27 -0700
comments: true
categories: android
---

So I was learning to animate Views in Android using [this video] and was having trouble with the second time the animation runned. First run the objects end up in their destination, second run it was mayhem. 
I had fallen victim to the great misunderstanding everyone makes about Android animations: **they are just a magic trick**.

<!--more-->

The animated View isn't actually moving (or rotating, or scaling, or fading). The animation is actually just an order to the rendering engine to perform a last minute transformation on the desired object. **The real object never leaves it's initial position.**

So the first time my animation runned I was making the view move from A to B. Now the second time I was trying to move it from B to C, but even when I was seeing the View in B (because I've setted the `android:fillAfter="true"` flag) the real object was in A the whole time. Therefore the second run of the animation ended up in disaster.

To fix this there are 2 solutions:

1. Update the View object once the animation has finished using an [AnimationListener] and do it `onAnimationEnd()`.
2. Use an [ObjectAnimator] which updates the underlying property while performing the animation. Or use [NineOldAndroids] if your target sdk is <11.

[this video]: http://youtu.be/_UWXqFBF86U]
[AnimationListener]: http://developer.android.com/reference/android/view/animation/Animation.AnimationListener.html
[ObjectAnimator]: http://developer.android.com/reference/android/animation/ObjectAnimator.html
[NineOldAndroids]: http://nineoldandroids.com/