---
layout: post
title: "Oracle, JPA and the mystery of the String that was null"
date: 2018-06-23 10:34:26 -0700
comments: true
categories: oracle oracle-db jpa spring spring-data kotlin h2 nulls npe 
---

This is the story of how Oracle DB was messing up Kotlin’s type system, and what I did to fix it.

<!--more-->

## The setup

Let’s start by _setting the stage_, for this particular project I was working with the following stack:

{% img center /images/posts/2018-06-23/Stack.png 720 ’Spring + Data + Kotlin + Oracle’ %}

## The problem

So I had modeled the following **Entity** leveraging Kotlin’s [data classes][1][^1]:

<xmp class="kotlin-code" data-highlight-only>
import javax.persistence.Entity
import javax.persistence.Id

//sampleStart
@Entity
data class Person(
	val name: String,
	@Id val id: Long? = null
)
//sampleEnd
</xmp>

Tests where passing with flying colors, but for some reason we were noticing that **the _name_ would sometimes come back as `null`** even thought it was typed as `String` and not `String?`.

## The analysis

To make things more difficult there where other failures in the communication layer masking the real issue. But we finally figured out what was happening when we notice **it was only reproducible under the following conditions**:

- The property `name` was empty
- Not reproducible on tests
- Persisting to _OracleDB_ (instead of embedded H2)

That’s when I discovered: 
{% blockquote Some guy on Stack Overflow https://stackoverflow.com/a/13278879/1499171 %}
This is because Oracle internally changes empty string to NULL values. Oracle simply won't let insert an empty string.
{% endblockquote %}

So when the data was mapped back to my `Person` object I ended up with a `null` value for _name_. This is probably only possible because **Hibernate is using reflection to set the field value** in runtime, thus breaking Kotlin’s [null safety][2].

## What I did about it

The funny thing about this one is that **there is not much you can do about it**. _There is no magic configuration to tell Oracle how you want to handle empty strings._ Yes there are some hacks like changing `""` to `" "` but I’d rather invent a random _name_ for the guy than persisting a whitespace.

The silver lining is that most of the time **if you’re not allowing null values you probably don’t want an empty string either**. Now YMMV but I know this was true for a person’s name. 

In fact you might even want to **implement a more strict validation** so people can’t be named: “💩”.

### Testing

First thing I did was to try to reproduce this using a test. But since I was using `@DataJpaTest` with H2 embedded DB empty strings where empty strings an nulls where nulls. So the issue was **not reproducible**.

That’s when I learned that you **can tell H2 to behave like an Oracle DB** using [Oracle Compatibility mode][3]. To achieve this I added the following configuration to my `application.yml` under `test/resources`:

```
spring:
  datasource:
    url: jdbc:h2:mem:testdb;Mode=Oracle
```

And annotated my test class with:

``` java
@RunWith(SpringRunner::class)
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class FormRepositoryTest {…}
```

And _voilà_, now you have an **H2 in memory DB dressed up as Oracle**. 

### Changing the schema

The other thing I realized is that **the schema allowed for `null` values** on the _name_ column. I’d been using `javax.persistence.schema-generation` as a starting point for my schema and **I wrongly assumed** it would take the hint from the Kotlin type system to prevent null values[^2].

Instead I had to explicitly annotate my Entity:

<xmp class="kotlin-code" data-highlight-only>
import javax.persistence.Entity
import javax.persistence.Id

//sampleStart
@Entity
data class Person(
	@Column(nullable = false) val name: String,
	@Id val id: Long? = null
)
//sampleEnd
</xmp>

and manually change my existing schema

```
CREATE TABLE Person (
  id NUMBER(19, 0) NOT NULL,
  name VARCHAR2(255 CHAR) NOT NULL,
  PRIMARY KEY (id)
);
```

The result is that now if somebody tries to persist a Person with an empty name a **big fat Exception is thrown**. Or at least until I implement proper name validation.

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	If I had a dollar for every time I modeled a Person…

[^2]:	It would be nice right?

[1]:	https://kotlinlang.org/docs/reference/data-classes.html
[2]:	https://kotlinlang.org/docs/reference/null-safety.html
[3]:	http://www.h2database.com/html/features.html