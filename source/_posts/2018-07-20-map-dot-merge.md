---
layout: post
title: "Map.merge"
date: 2018-07-20 07:32:49 -0700
comments: true
categories: java java8 jdk8 collections map
---

Sometimes is the small things… Like finding a new method that does exactly what you were needing.

<!--more-->

Let’s say I’m trying to build a book index. In case you haven’t touch an actual, physical, _dead-tree_ book in a while here’s what an index looks like[^1]:

{% img center /images/posts/2018-07-20/index.gif 'Discoverability' %} 

One way of doing this would be to **build a map of: _terms_ to _a list of comma separated pages_**. This is, by no means, the best way of modeling an index, but it’ll serve our purpose of illustrating the [`Map.merge`][1] method.

Up until yesterday I’d have written such code like this:

{% codeblock lang:java %}
public class Index {
	private final Map<String, String> termToPagesMap = new HashMap<>();
	
	public void addWord(String term, int page) {
	    final String newPage = String.valueOf(page);
	    final String pages = termToPagesMap.get(term);
	    if (pages == null) {
	        termToPagesMap.put(term, newPage);
	    } else {
	        termToPagesMap.put(term, pages.concat(", " + newPage));
	    }
	}
}

{% endcodeblock %}

**But today I know better!** With [`Map.merge`][2] I can achieve the same result in just 1 line:

{% codeblock lang:java %}
public class Index {
	private final Map<String, String> termToPagesMap = new HashMap<>();
	
	public void addWord(String term, int page) {
	        termToPagesMap.merge(term, String.valueOf(page), (pages, newPage) -> pages.concat(", " + newPage));
	}
}
{% endcodeblock %}

Basically we provide:

* The entry **key**
* A **value** to be used if there was no associated value to the key (or it was `null`)
* A ** remapping function** that takes the **old value**, the **new value** and calculates the new value for the map

## Bonus track: Removal

There’s one more trick you can do with `Map.merge`. Citing the [documentation][3]:

> If the function returns `null` the mapping is removed

Something to keep in mind in case it comes in handy in the future. Or if you find yourself debugging an issue of _”vanishing entries on a Map”_, then maybe you should check your ** remapping function** 😉

[^1]:	I’m aware that ebooks have indexes too, but who the fuck uses them when you can do a full blown text search

[1]:	https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#merge-K-V-java.util.function.BiFunction-
[2]:	https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#merge-K-V-java.util.function.BiFunction-
[3]:	https://docs.oracle.com/javase/8/docs/api/java/util/Map.html#merge-K-V-java.util.function.BiFunction-