---
layout: post
title: "Value Types the easy way"
date: 2014-04-07 20:54:07 -0700
comments: true
categories: java lib 
---
Value types is a fancy name for those classes where you have to implement `equals()` and `hashCode()`, and usually `toString()`. You've probably wrote thounsands of those classes, but have you ever wonder why do you have write almost 50 lines of code to express such a common concept?

<!-- more -->

Let's say you want to model an Employee, with name and age. If you were to write it following all of [Effective Java's] advices (which is how you always roll, right?) you would get something like this:

``` java
public class EmployeeTheOldFashionedWay {

    private final String name;
    private final int age;

    public EmployeeTheOldFashionedWay(String name, int age) {
        this.name = name;
        this.age = age;
    }

    public String getName() {
        return name;
    }

    public int getAge() {
        return age;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        EmployeeTheOldFashionedWay that = (EmployeeTheOldFashionedWay) o;

        if (age != that.age) return false;
        if (!name.equals(that.name)) return false;

        return true;
    }

    @Override
    public int hashCode() {
        int result = name.hashCode();
        result = 31 * result + age;
        return result;
    }

    @Override
    public String toString() {
        return "EmployeeTheOldFashionedWay{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

This is wrong for many reasons:

* Way too long
* Obvious violation of the [DRY] principle
* You won't tests this methods
* They won't be closely reviewed
* This classes **will** change and that's when bugs are introduced
* Bad signal-to-noise in your code (i.e. too much code to express such an easy concept)

Perhaps you are aware that this code can be easily written using IDE Templates. Your favorite IDE can generate constructor based on fields, getters, `equals()`, `hashCode()` and `toString()` methods letting you write value types classes in a breeze. But then all the things we said are wrong with the value type still hold. The only thing we achieve is to write them faster.

### Google AutoValue ###
What I'm presenting today is Google's solution to the value types issue. With [AutoValue] you could write the same Employee class in approximately 10 lines of code like this:

``` java
@AutoValue
public abstract class EmployeeWithAutoValue {
    public static EmployeeWithAutoValue create(String name, int age) {
        return new AutoValue_EmployeeWithAutoValue(name, age);
    }

    public abstract String getName();

    public abstract int getAge();
}
```

#### What the heck just happened there? ####
That `@AutoValue` annotation you see on the class is just a standard annotation that generates a package private implementation for your abstract class called: _AutoValue_EmployeeWithAutoValue_. In case you were wondering [this is how that implementation looks like].

Is this the best alternative? I don't really know... but in [this presentation] the authors of AutoValue compare it to other solutions and explain why they think theirs is better.

#### Usage ####

This is how you use your Employee class: 

```java
public static void main(String[] args) {
        EmployeeWithAutoValue employee = EmployeeWithAutoValue.create("Juan", 33);
        System.out.println("employee.getName() = " + employee.getName());
        System.out.println("employee.getAge() = " + employee.getAge());
    }
```

Pretty regular stuff over here. That's one of the good things of AutoValue: consumers don't need to know what's going on behind the scenes.

#### Features and drawbacks ####

* You can't use constructors but you can use any number of static factory methods you like. Which if you have read [Effective Java Item 1] you know is a good idea anyway.
* No support for _mutable_ value types. Again you are better off using immutables anyway.
* If you want to provide your own implementation of `equals()`, `hashCode()` or `toString()` you can! Just add your own method to the class and autovalue won't generate it in the implementation.
* AutoValue assumes all your non-primitive fields are not nullable and add checks in the generated code. You can modify this behaviour applying the annotation `@Nullable` to the corresponding accessor method and factory parameter.
* You _can_ add behaviour to your class
* You _can_ implement interfaces
* __WARNING!__ The big disadvantage. The generator has to choose an order for the constructor parameters, so it uses the order in which they appear in the file. That means that a simple refactor moving the accessors can break the abstract class or worse silently mix the parameters. __You've been warned!__

#### Making it work in IntelliJ Idea ####
I used Intellij Idea to try this and I must say it took me some time to get the generated class folder to be marked as src. In the end what did the trick was to reimport the mvn project.
Just know that once it has been added as a src folder you'll have to compile the code one time before the IDE can tell there is a generated class named _Autovalue_XXX._ You can add this to the list of minor annoyances of using AutoValue if you like.


[Effective Java's]: http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683

[DRY]: http://en.wikipedia.org/wiki/Don't_repeat_yourself

[AutoValue]: https://github.com/google/auto/tree/master/value

[this is how that implementation looks like]: https://gist.github.com/jivimberg/ca86f975e3945e30978f

[Effective Java Item 1]: http://my.safaribooksonline.com/book/programming/java/9780137150021/creating-and-destroying-objects/ch02lev1sec1

[this presentation]: https://docs.google.com/presentation/d/14u_h-lMn7f1rXE1nDiLX0azS3IkgjGl5uxp5jGJ75RE/edit