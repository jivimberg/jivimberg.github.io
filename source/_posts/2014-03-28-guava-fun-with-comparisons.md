---
layout: post
title: "Guava - Fun with Comparisons"
date: 2014-03-28 17:26:47 -0700
comments: true
categories: java guava libs
---

Implementing `compare()` and `compareTo()` methods was never fun. Luckily [Guava] provides an utility that makes comparison methods easier to write and more pleasing to the eye.

<!--more-->

So let's say we have the class `Person`:

``` java
private class Person {
        private String name;
        private int zipCode;
        private Age age;
}

private enum Age { YOUNG, OLD }
```

And we want to sort it by name, then by zipcode and finally, if they are still matched, by age (having `Age.YOUNG` first) but making `null` values greater than non `null` values.

Such comparator could look something like this:

``` java
public class VerboseComparator
            implements Comparator<Person>
    {

        @Override
        public int compare(Person o1, Person o2) {
            int cmp = o1.name.compareTo(o2.name);
            if (cmp != 0) {
                return cmp;
            }

            cmp = Integer.compare(o1.zipCode, o2.zipCode);
            if (cmp != 0) {
                return cmp;
            }

            if(o1.age == null && o2.age != null){
                return -1;
            } else if (o1.age != null && o2.age == null) {
                return 1;
            } else if (o1.age == null && o2.age == null) {
                return 0;
            } else {
                return o1.age.compareTo(o2.age);
            }
        }
    }
```  
Yeah I know, it's hard to read, prone to errors and it has a way too many if statements.

But _Don't Panic!_ with Guava we can write this same comparator like this:

``` java
private static class GuavaComparator
            implements Comparator<Person>
    {

        @Override
        public int compare(Person o1, Person o2) {
            return ComparisonChain.start()
                    .compare(o1.name, o2.name)
                    .compare(o1.zipCode, o2.zipCode)
                    .compare(o1.age, o2.age, Ordering.natural().nullsFirst())
                    .result();
        }
    }

```

That looks way better and it's easier to understand.

Furthermore ComparisonChain stops calling the next `compare()` method as soon as one returns a value different than 0. So if you have an expensive calculation for comparison to untide similar objects you can rest assured it will only be called when absolutely necessary.

If you find this useful you'll probably want to check out other [guava's Ordering Utilities].

[Guava]: https://code.google.com/p/guava-libraries/
[guava's Ordering Utilities]: https://code.google.com/p/guava-libraries/wiki/OrderingExplained