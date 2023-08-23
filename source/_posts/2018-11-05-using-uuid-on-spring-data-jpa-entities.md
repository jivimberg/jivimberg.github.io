---
layout: post
title: "Using UUID on Spring Data JPA entities"
date: 2018-11-05 07:25:37 -0800
comments: true
categories: uuid spring data jpa kotlin hibernate 
---

In this article I’ll explore **how to model a [JPA Entity][1] using an [UUID][2]** as Primary Key working with [Spring Data JPA.][3]

<!--more-->

{% img center /images/posts/2018-11-07/uuid.png ‘uuid key’ %} 

# Why UUIDs?

Usually we use numerical keys on our models and let the DB generate that for us on persistence. But there are **some reasons why you might prefer to use UUIDs** as your Primary Key instead. Namely:

* **UUIDs are globally unique.** This means that we don’t need a centralized component to generate unique ids, **we can generate the ids on the application itself** instead of relying on [some UUID generator][4] that populates the `id` field on persist.
* Having globally unique ids also means that **your ids are unique across databases.** This allows us to move data across databases without having to check for conflicting ids.
* Having application generated ids means the id is known even before the entity is persisted. This lets us **model our entities as [immutable objects][5]** and we avoid having to handle null values on the id.

But as you probably already know: [🚫🆓🍽][6]. So here are some of the downsides of using UUIDss for you to consider:

* **Storage space.** As you can imagine storing an UUID takes a lot more space than storying an Int. Specially if you make the mistake of storing it as a `String`. You might think Id space is not a big deal, but consider that **Primary Keys are often used in indexes and as Foreign Keys on other tables**. So the numbers start to add up.
* They are **not human friendly**. What’s easier to remember: `223492` or `453bd9d7-83c0-47fb-b42e-0ab045b29f83 `? This is specially true if you happen to be exposing your ids on your public APIs. Think: `/albums/2311445/photo/7426321` vs `/albums/b3480d79-e458-4675-a7ba-61ac5957cb7c/photo/19b24967-1741-4405-a746-d2b081ee45f2 `.

**If you’re still on the fence** here’s a great article talking about the pros and cons of using UUIDs as primary keys: [https://tomharrisonjr.com/uuid-or-guid-as-primary-keys-be-careful-7b2aa3dcb439][7].

# How to do it

Now let’s talk about how we can implement this. I’ll go step by step explaining why we add each piece of code.

The first thing we need to do is **generate the UUID**. As mentioned above we’d like to do this on the application code so we can have _immutable entities_. Generating the UUID is easy, all we need to do is: `UUID.randomUUID()`. So our entity would look like this:

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import java.util.\*
import javax.persistence.Id
import javax.persistence.Entity

//sampleStart
@Entity
class Artist(
	    @Id val id: UUID = UUID.randomUUID(),
	    val name: String
)
//sampleEnd
</xmp>

You’ve probably noticed how we’re making the id an argument of the [primary constructor][8]. This is required to **let clients construct entities with known ids to represent persisted objects**. This is useful for example to **model an update operation**: create an enwtity with a known id and updated values, then call `save()` on such entity.

## isNew?

As mentioned we’re using [Spring Data JPA][9] for our Repository layer. Now there’s a small detail we have to take into account when **using application provided ids with Spring Data**. If you do a `artistRepository.save(Artist(name = "David Bowie"))` you might get an output like this:

{% img center /images/posts/2018-11-07/2sql.png ‘persist logs’ %} 

If you pay close attention to the log you’ll notice that **Hibernate is actually executing 2 SQL queries**: one `select` followed by one `insert`. Not quite what we were expecting.  

The reason for this behavior is the implementation of Spring Data’s [`SimpleJpaRepository.java`][10]. In particular the [`save()`][11] method:

```java
@Transactional
public <S extends T> S save(S entity) {
    if (entityInformation.isNew(entity)) {
        em.persist(entity);
        return entity;
    } else {
        return em.merge(entity);
    }
}
```

**The double SQL statement is caused by the call to `merge()`**. By default the way this class decides whether to do a `persist()` or a `merge()` **is simply by checking if the id is null**. Which works fine for DB assigned ids, but _not_ for application assigned ones. 😕

**The best way to control this is by implementing the [`Persistable<ID>`][12] interface** providing a `isNew()` method. Since this is something we’ll want to do every time we use application generated UUIDs **I’ll extract this into an abstract class** and making use of the `@MappedSuperClass` annotation.

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import org.springframework.data.domain.Persistable
import java.util.\*
import javax.persistence.\*

//sampleStart
@MappedSuperclass
abstract class AbstractBaseEntity(givenId: UUID? = null) : Persistable<UUID> {

	@Id
	@Column(name = "id", length = 16, unique = true, nullable = false)
	private val id: UUID = givenId ?: UUID.randomUUID()
	
	@Transient
	private var persisted: Boolean = givenId != null
	
	override fun getId(): UUID = id
	
	override fun isNew(): Boolean = !persisted
	
	override fun hashCode(): Int = id.hashCode()
	
	override fun equals(other: Any?): Boolean {
	    return when {
	        this === other -> true
	        other == null -> false
	        other !is AbstractBaseEntity -> false
	        else -> getId() == other.getId()
	    }
	}
	
	@PostPersist
	@PostLoad
	private fun setPersisted() {
	    persisted = true
	}
}
//sampleEnd

</xmp>

> This design was **suggested to me by [@paschmid][13] and [@rcruzjo][14]**, this code would be quite ugly if it weren’t for them!

You can see how the `persisted` state is decided based on whether an id is provided on creation or not, to account for updates. Also notice how **its value gets automatically updated upon _persist_ and _load_** thanks to `@PostPersist` and `@PostLoad` annotations.

Also since `id` is now _unique_ and _non-nullable_ **we can use it to implement `equals()` and `hashcode()`** and avoid falling in some of the common pitfalls of implementing this methods (to learn more about this check [this article][15] by [@vlad\_mihalcea][16] and [this one][17] by [@s1m0nw1][18]).

And in case you’re wondering **why we need an explicit `getId()` function**, it is because of this issue: [Kotlin properties do not override Java-style getters and setters][19].

# Putting it all together

Finally let’s see how a concrete entity would use this.

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import org.springframework.data.repository.CrudRepository
import java.util.\*
import javax.persistence.Entity

//sampleStart
@Entity
class Artist(
	    id: UUID? = null,
	    val name: String
) : AssignedIdBaseEntity(id)
//sampleEnd
</xmp>

Pretty similar to our original approach right? Thanks to the abstract class all the `isNew()` **implementation details are hidden** from concrete entities.

And now if we do a `save()` on a new entity **we get one single SQL statement** as we were expecting.

{% img center /images/posts/2018-11-07/1sql.png 600 ‘persist logs with abstractEntity’ %} 

---- 

# Approach 2: Making it simpler with @Version

This approach was suggested by [Diego Marin][20] in the comments. 

Spring Data can leverage the existence of a `@Version` field to tell if the Entity is present or not. By having `@Version`, we also get [Optimistic Locking][21] for free.

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import java.util.*
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.Version

//sampleStart
@Entity
class Celeb(
        @Id @Column(name = "id", length = 16, unique = true, nullable = false)
        val id: UUID = UUID.randomUUID(),
        @Version
        val version: Long? = null,
        val name: String
) {
    override fun equals(other: Any?) = when {
        this === other -> true
        javaClass != other?.javaClass -> false
        id != (other as Celeb).id -> false
        else -> true
    }

    override fun hashCode(): Int = id.hashCode()
}
//sampleEnd
</xmp>

> ⚠️ Make sure you’re importing `javax.persistence.Version` and NOT `org.springframework.data.annotation.Version`!

We still need to write the `id` column definition and `equal` and `hashCode` methods, so if this is something you’ll be applying in most of your entities you might want to consider extracting it to a superclass. Similar to what we did with `AssignedIdBaseEntity`, but using `@Version` 

---- 

You can find all the **code samples** for this post on **[this GitHub repo][22]**.

{% img right-fill /images/signatures/signature1.png 200 ‘My signature’ %} 

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[1]:	https://stackoverflow.com/questions/6033905/create-the-perfect-jpa-entity
[2]:	https://en.wikipedia.org/wiki/Universally_unique_identifier
[3]:	https://spring.io/projects/spring-data-jpa
[4]:	https://vladmihalcea.com/hibernate-and-uuid-identifiers/
[5]:	https://proandroiddev.com/kotlin-for-beginners-immutability-and-the-value-of-val-78ab45b60b57
[6]:	https://en.wikipedia.org/wiki/There_ain't_no_such_thing_as_a_free_lunch
[7]:	https://tomharrisonjr.com/uuid-or-guid-as-primary-keys-be-careful-7b2aa3dcb439
[8]:	https://kotlinlang.org/docs/reference/classes.html#constructors
[9]:	https://spring.io/projects/spring-data-jpa
[10]:	https://github.com/spring-projects/spring-data-jpa/blob/master/src/main/java/org/springframework/data/jpa/repository/support/SimpleJpaRepository.java
[11]:	https://github.com/spring-projects/spring-data-jpa/blob/01e36dbb44d6bc87f7deb3b6d6dacc955ea6c8bd/src/main/java/org/springframework/data/jpa/repository/support/SimpleJpaRepository.java#L506
[12]:	https://github.com/spring-projects/spring-data-commons/blob/master/src/main/java/org/springframework/data/domain/Persistable.java
[13]:	https://twitter.com/PabloHernanS
[14]:	https://twitter.com/rcruzjo
[15]:	https://vladmihalcea.com/how-to-implement-equals-and-hashcode-using-the-jpa-entity-identifier/
[16]:	https://twitter.com/vlad_mihalcea
[17]:	https://kotlinexpertise.com/hibernate-with-kotlin-spring-boot/
[18]:	https://twitter.com/s1m0nw1
[19]:	https://youtrack.jetbrains.com/issue/KT-6653
[20]:	https://disqus.com/by/disqus_UhNaTY8OWI/
[21]:	https://www.baeldung.com/jpa-optimistic-locking
[22]:	https://github.com/jivimberg/spring-data-uuid-example