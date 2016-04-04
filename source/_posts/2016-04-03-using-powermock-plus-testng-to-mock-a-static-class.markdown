---
layout: post
title: "Using PowerMock + TestNG to mock a static class"
date: 2016-04-03 08:38:47 -0700
comments: true
categories: testing mocking java
---
￼
This week I needed to test a class that depended on a method from an static class. I saw we were using [PowerMock][1] and thought to myself: _“Well this sounds pretty common, I bet it’s easy to accomplish”_. But of course I ran into half a dozen issues before I was able to make it work. Here’s my two cents to make your experience easier than mine.

<!--more-->

## Setup
Let’s start with the ingredients. To mock static methods you’ll need a couple of libraries:

* [EasyMock][2] for the mocking[^1]
* [PowerMock][3]
* [TestNG][4] for the test

When choosing your library version you’ll need to make sure **PowerMock** and **TestNG** versions are compatible. You can do so by comparing your versions with the ones specified [here][5].

Also, if you’re not using **Maven** to include PowerMock in your project make sure you also add it’s dependencies. You’ll find a zip file containing everything you need [here][6].

## Writing the test
To have the test working you’ll need to do 3 things:

1. Configure **TestNG** to use the PowerMock object factory
2. User `@PrepareForTest` annotation to prepare the static class
3. Mock the static class method
4. Write the rest of the test

Let’s go one by one:

#### 1. Configure TestNG to use the PowerMock object factory
There are a bunch of ways of doing this, namely:

* Configure it on the `suite.xml` file
* Extending your test class with `PowerMockTestCase`
* Or by adding a method like this to your test 

```java
@ObjectFactory
public IObjectFactory getObjectFactory() {
	return new org.powermock.modules.testng.PowerMockObjectFactory();
}
```

I choose to go with the latter because I don’t use the `suite.xml` file and adding an annotated method is less restrictive than extending a class. But feel free to use the way that better suits your purpose

#### 2. @PrepareForTest
You’ll need to prepare your static class for mocking. You can do so with the `@PrepareForTest` annotation like this:

``` java
@PrepareForTest(StaticHelper.class)
public class MyTest {
	…
}
```

Note that you can pass an array of classes to the annotation if you need to prepare multiple classes.

#### 3. Mocking

Now you’re ready to mock the static method like this:

``` java
PowerMock.mockStatic(StaticHelper.class);
EasyMock.expect(StaticHelper.doSomething()).andReturn(“hello world”)).anyTimes();
PowerMock.replay(StaticHelper.class);
```

#### 4. Writing the rest

Ok let’s put everything together and write the rest of the test

``` java
@PrepareForTest(StaticHelper.class)
public class MyTest {

@ObjectFactory
public IObjectFactory getObjectFactory() {
	return new org.powermock.modules.testng.PowerMockObjectFactory();
}

@Test
public void test() throws Exception {
	// mocking static method
	PowerMock.mockStatic(StaticHelper.class);
	EasyMock.expect(StaticHelper.doSomething()).andReturn(“hello  world”)).anyTimes();
	PowerMock.replay(StaticHelper.class);
	
	// test
	Assert.assertEquals(“hello world” ” StaticHelper.doSomething());
}

}
```
  
## Some things to watch out for
There are a few things to keep in mind when initializing the mock:

1. You cannot create mocks during field initialization.
2. You cannot create mocks inside before static methods.

Finally I also run into the following error when running my test: 

```
java.lang.VerifyError: Expecting a stackmap frame at branch target 71 in method com.abc.domain.myPackage.MyClass$JaxbAccessorM_getDescription_setDescription_java_lang_String.get(Ljava/lang/Object;)Ljava/lang/Object; at offset 20_
```

Turns out that, as explained [here][7] Java 7 introduced a stricter verification and changed the class format. The byte code generation library PowerMock uses is generating code. But worry not, **this validation can be disabled** by passing `-noverify` as argument to the JVM. 



[^1]:	This guide uses **EasyMock** but you can also use **Mockito**

[1]:	https://github.com/jayway/powermock "PowerMock"
[2]:	easymock.org "EasyMock"
[3]:	http://testng.org/ "http://testng.org"
[4]:	http://testng.org/
[5]:	https://github.com/jayway/powermock/wiki/TestNG_usage
[6]:	https://github.com/jayway/powermock/wiki/GettingStarted
[7]:	http://stackoverflow.com/questions/15122890/java-lang-verifyerror-expecting-a-stackmap-frame-at-branch-target-jdk-1-7