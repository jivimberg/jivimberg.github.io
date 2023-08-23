---
layout: post
title: "Guava - Using and avoiding null"
date: 2014-03-19 00:34:41 -0700
comments: true
categories: java guava libs
---
I'm starting a series of posts on [Guava](https://code.google.com/p/guava-libraries/) (Google's core libraries). Today I am going to start with **null**, how to use it, and how to avoid it when necessary. 

<!--more-->

>**"I call it my billion-dollar mistake."**  
Sir C. A. R. Hoare, on his invention of the null reference

###Null in Guava Collections###
How many times have you expected null values on your collections? And how many times have you _actually_ check to prevent null values on them?

That's why most of Guava "New Collections" and utilities will fail fast with a NPE when you try to add null to them. And they provide the **Optional** utilty for those cases where we need to indicate absence of some kind, without using null.

``` java
//This will fail with java.lang.NullPointerException: at index 2
ImmutableList.of("one", "two", null);
```

###Optional###
Optional is a way of representing a reference which may be present or not. The whole point of using Optional instead of null, is that there is no way the client can miss the case where the reference is absent. It forces him to actively unwrap the value or else the program won't compile.

Here is how you create an optional:

``` java
Optional<String> creatingAnOptional(){
        Optional<String> result;

        String value = findString(); //may return null
        result = Optional.fromNullable(value);

        // which is the same as doing:
        if(value != null){
            result = Optional.of(value);
        } else {
            result = Optional.absent();
        }

        return result;
    }
```    

And here is how you query for the value:

``` java
void queryingOptionals(){
        Optional<String> optional = creatingAnOptional();

        if(optional.isPresent()){
            String value = optional.get(); //We are sure is the value is there
            System.out.println("The string is: " + value);
        }

        //or
        System.out.println("Value or default: " + optional.or("Default value"));
    }
```

The next time you are writing a method that return a values which may or may not be present, remember to use Optional. It will make your API much clearer and force the caller to consider the absent value case.
