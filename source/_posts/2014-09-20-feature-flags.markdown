---
layout: post
title: "Feature Flags"
date: 2014-09-20 14:53:01 -0700
comments: true
categories: release management,
---
In this post I'll introduce the concept of Feature Toggles as a release alternative to [FeatureBranches]. This technique is also known as: Feature toggles, Feature switches, Feature flippers, etc.

<!-- more -->

{%ribbonp warning Disclamer%}
This article is HEAVILY based on Martin Fowler's FeatureToggle (http://martinfowler.com/bliki/FeatureToggle.html). Feel free to refer to the original article for further detail.
{%endribbonp%}

The basic idea of Feature Flags is to have a **configuration file** that defines a bunch of toggles for various features you are working on. The running application then uses these toggles in order to decide whether or not to show the new feature.

We can have features in the UI or in the application code. There they could be as crude as a conditional test, or something more sophisticated like a strategy wired through dependency injection.

Toggle checks should only appear at the minimum amount of points to ensure the new feature is properly hidden. Focus on just the entry points that would lead users there and toggle those entry points. If you find that creating, maintaining, or removing the toggles takes significant time, then that's a sign that you have too many toggle tests.

##Types of toggles##
Feature toggles come in 2 flavors:

1. **Release toggles:** Used to hide partly build features.
2. **Business toggles:** Used to selectively turn on features in regular use. For example to only expose certain features when the application is running in a particular environment configuration.

Release toggles are primarily visible to the development organization and should be retired once the feature has bedded down in the application. Business toggles are visible to the business sponsors and are a permanent feature of the application. This means that **the two kinds of toggles need to be clearly separated**, usually appearing in separate configuration files.

Another way of dividing the toggles is by the time they are set. Here we have:

1. Set at runtime
2. Set at build time

You often need to build some admin tooling to help control of business toggles that can change at runtime.

##Testing##
In general there's no need to test all combinations of features. For release toggles it's usually sufficient to run two combinations:

1. All the toggles on that are expected to be on in the next release
2. All toggles on

For business toggles the combination problem is greater, since you do need to consider the various combinations that appear in practice and how they might interfere. You usually won't need to test every combination, but what subset of combinations you need depends on your knowledge of how the application performs in production.

[FeatureToggles]: http://martinfowler.com/bliki/FeatureToggle.html
[FeatureBranches]: http://martinfowler.com/bliki/FeatureBranch.html

