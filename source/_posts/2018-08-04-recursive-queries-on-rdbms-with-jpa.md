---
layout: post
title: Hierarchical queries on RDBMS with JPA
date: 2018-08-04 11:29:52 -0700
comments: true
categories: JPA SQL recursive query RDBMS hierarchical graph kotlin
---

Hello! In this post I’ll explore the different alternatives for querying hierarchical data stored on a RDBMS using [JPA][1].

<!--more-->

# What are we trying to do?

Let’s use a silly example to illustrate what we are trying to achieve. Say we want to model **mother-daughter relationships**, we can do so with an entity like this:

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import javax.persistence.CascadeType
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.OneToMany

//sampleStart
@Entity
data class Woman (
	val name: String,
	@OneToMany(cascade = [CascadeType.ALL]) val daughters: MutableSet<Woman> = mutableSetOf(),
	@Id @GeneratedValue(strategy = GenerationType.AUTO) val id: Long? = null
)
//sampleEnd

\~</xmp>

In OO-talk that’s just one Type with a reference to itself like this:

{% img center /images/posts/2018-08-04/UML.jpg 240 ’UML’ %}

And once we start creating a bunch of mothers, we’ll get a [directed acyclic graph][3]. Although for this example, and to keep things simple, **we’ll just model the offspring of just one single person** so we get a nice tree like this:

{% img center /images/posts/2018-08-04/tree.jpg 480 ’Tree’ %}

But in DB this is stored in **2 tables**. One contains the Woman data and the other one the relationships.

{% codeblock %}

| Id | Name   |       | Woman_Id |  Daughters_Id | 
|----|--------|       |----------|---------------| 
| 1  | Wendy  |       | 1        | 2             | 
| 1  | Wendy  |       | 1        | 3             | 
| 2  | Brenda |       | 2        | 4             | 
| 2  | Brenda |       | 2        | 5             | 
| 3  | Carol  |       | 3        | 6             | 
| 4  | Linda  |   
| 5  | Betty  |   
| 6  | Lisa   |    

{% endcodeblock %}

We’ll focus in just one single type of query, namely: 

> _Find a node and return the whole subtree underneath_

Or in domain specific terms:

> _Find a woman and return her along with her offspring_

# Alternatives

Let’s explore our options. For the following examples I’ll be using [Kotlin][5], [Spring Data][6], [JPA][7], [Hibernate][8] and an [Oracle Database][9]. Thanks to JPA you’ll notice that most of the time **the solutions provided work on whatever you’ve decided to use** (I’ll note it when it’s not the case). You can use Java instead of Kotlin, Eclipselink instead of Hibernate and MySQL instead of Oracle, and even abandon Spring completely. 

Because this is meant to be a formative post **I’ll start with some of the “wrong” approaches first** and explain its downsides. If you’re in a rush you can just scroll to the bottom 😃

## Eager fetching

The simplest solution is using [Eager fetching][10]. We can enable eager fetching specifying the `fetch` parameter on the `@OneToMany`  annotation like this:

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import javax.persistence.CascadeType
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.OneToMany

//sampleStart
@Entity
data class Woman (
	val name: String,
	@OneToMany(fetch = FetchType.EAGER, cascade = [CascadeType.ALL]) val daughters: MutableSet<Woman> = mutableSetOf(),
	@Id @GeneratedValue(strategy = GenerationType.AUTO) val id: Long? = null
)
//sampleEnd

</xmp>
 
Great, it works! But wait, _why do I see so many SELECT calls to the database?_ As you’ve probably figured out the issue with this approach is that it falls in the [N + 1 SELECT problem][11]. 

Some authors even go as far as considering [eager fetching a **code smell**][12]. In the words of [Vlad Mihalcea][13] (emphasis mine):

> The EAGER fetching strategy is a code smell. Most often it’s used for simplicity sake without considering the long-term performance penalties. The fetching strategy **should never be the entity mapping responsibility**. Each business use case has different entity load requirements and therefore the fetching strategy should be delegated to each individual query.

## Using `join fetch`

Another alternative would be to use `join fetch` as part of the JPQL query.

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
fun findWomanUsingJoinFetch(id: Long): Woman? {
	    return em.createQuery("select distinct w from Woman w left join fetch w.daughters", Woman::class.java)
	    .resultList
	    .find { it.id == id }
}
</xmp>

With `join fetch` we can tell JPA to do a `join` to execute the query and also include the data as part of the response object when mapping to the OO world.

The _huge downside_ is that we’re actually **querying ALL women**  and only then selecting the one we were looking for from the `resultList`. This means that, unless you’re querying for the root node, **you’ll always be doing extra work**.

And no, a `where` clause can’t help us here. Using `where w.id = :id` would leave us with just the root and one level of descendants in the _resultList_.

Unfortunately **I couldn’t find a way of making this a single JPQL query**.  [Vlad Mihalcea][14] has a [great article][15] explaining how to use `join fetch` to query all the leaves of the tree and then build the associations all the way up the entity hierarchy. Sadly we can’t apply the same approach here because we’re querying a _multi-level homogeneous tree_. That means that **all the nodes are of the same type, and thus mapped to the same table,** and furthermore leaves can be N levels deep. So if we try Vlad’s approach we’d end up with the similar **`where` problem** mentioned above.

## Entity graph

Another proposed solution is to use [Entity Graphs][16] introduced in _JPA 2.1_. You can use Entity Graphs as a query hint to **specify which fields you want eagerly fetched as part of the query**.

> Entity graphs have attributes that correspond to the fields that will be eagerly fetched during a find or query operation

They come in 2 flavors. Static through annotations:

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
import javax.persistence.CascadeType
import javax.persistence.Entity
import javax.persistence.FetchType
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.NamedAttributeNode
import javax.persistence.NamedEntityGraph
import javax.persistence.NamedEntityGraphs
import javax.persistence.NamedSubgraph
import javax.persistence.OneToMany

//sampleStart
@Entity
@NamedEntityGraphs(
	NamedEntityGraph(name = "womanWithDaughters",
	    attributeNodes = [NamedAttributeNode(value = "daughters", subgraph = "daughterWithDaughters")],
	    subgraphs = [
	        NamedSubgraph(
	            name = "daughterWithDaughters",
	            attributeNodes = [NamedAttributeNode("daughters")]
	        )
	    ]
	)
)
data class Woman (
//sampleEnd
	val name: String,
	@OneToMany(fetch = FetchType.EAGER, cascade = [CascadeType.ALL]) val daughters: MutableSet<Woman> = mutableSetOf(),
	@Id @GeneratedValue(strategy = GenerationType.AUTO) val id: Long? = null
)
</xmp>

Or you can construct the graph **programmatically** to have some more flexibility:

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
fun findWomanUsingEntityGraph(id: Long): Woman {
	val graph = em.createEntityGraph(Woman::class.java)
	    .also { it.addSubgraph<Woman>("daughters") }
	return em.find(Woman::class.java, id, mapOf("javax.persistence.loadgraph" to graph))
}
</xmp>

I thought: _“This is it IT! If I can manually build the graph for each query I can even specify how many levels deep I want to go”_. But once again, it didn’t quite work 😞

I tried creating graphs with subgraphs N levels deep but **the query would just ignore them and only fetch up to 2 levels**. From the annotations flavor this limitation is clear since:

1. You can’t use a subgraph reference on an attribute of the same graph recursively (it’ll fail at runtime)
2. And `@NamedSubgraph` can’t have other `subgraphs` defined underneath.

I was hoping this would be possible through the API, but apparently it’s not. Maybe Hibernate is to blame here, I don’t really know… But _I couldn’t find any documentation beyond the basic 2 level example_.

## Using `@BatchSize`

Going back to the Eager Fetch approach, we hated it because it resulted in N queries where N is the number of Women in the table. **With  `@BatchSize` we can mitigate this**.

<xmp class="kotlin-code" theme="darcula" data-highlight-only>
data class Woman(
	val name: String,
	@BatchSize(size = 10)
	@OneToMany(fetch = FetchType.EAGER, cascade = [CascadeType.ALL]) val daughters: MutableSet<Woman> = mutableSetOf(),
	@Id @GeneratedValue(strategy = GenerationType.AUTO) val id: Long? = null
)
</xmp>

By setting the batch size to 10 we’re basically saying: _“Since you’re going to the DB to execute a query bring up to 10 elements instead of just one”_. Effectively **reducing the number of roundtrips to the database**. 

`@BatchSize` is a [Hibernate specific annotation][17] but on Eclipselink you can use [`eclipselink.batch.size`][18] to achieve the same result. In fact, remember that as a rule of thumb  **it’s better to apply this kind of configurations to the query** instead of using an annotation on the entity. 

## Connect by (Best solution!)

If you’re using Oracle then we can solve this using a native query with [`CONNECT BY`][19]. Turns out this clause was created specifically for **selecting rows in hierarchical order**.

{% img center /images/posts/2018-08-04/connectby.gif  ’Connect by syntax’ %}

We use `START WITH` to specify the root node of the hierarchy, and then `CONNECT BY` to specify the relationship between rows. Our query would look like this:

{% codeblock lang:sql %}

SELECT w.id, w.name, wd.daughters_id
FROM woman w
LEFT JOIN woman_daughters wd ON w.id = wd.woman_id
START WITH w.id = ?1
CONNECT BY PRIOR wd.daughters_id = w.id

{% endcodeblock %}

Note how in the `CONNECT BY` clause we use `PRIOR` to refer to the parent row.

This achieves exactly what we want **in just one query!**. But this doesn’t come for free. By using native queries we are stepping out of the _JPA magical world™_. This means that what the query returns is not an object but a list of rows of the form:

{% codeblock %}

| Id | Name   | Daughters_id | 
|----|--------|--------------| 
| 1  | Wendy  | 2            | 
| 1  | Wendy  | 3            | 
| 2  | Brenda | 4            | 
| 2  | Brenda | 5            | 
| 3  | Carol  | 6            | 
| 4  | Linda  | null         | 
| 5  | Betty  | null         | 
| 6  | Lisa   | null         | 

{% endcodeblock %}

So we’ll have to write the code to transform this back to our domain model. To achieve this I used the `@SqlResultSetMapping` to model the native query result. 

<xmp class="kotlin-code" theme="darcula"data-highlight-only>
	import javax.persistence.CascadeType
import javax.persistence.ColumnResult
import javax.persistence.ConstructorResult
import javax.persistence.Entity
import javax.persistence.EntityManager
import javax.persistence.GeneratedValue
import javax.persistence.GenerationType
import javax.persistence.Id
import javax.persistence.OneToMany
import javax.persistence.SqlResultSetMapping

//sampleStart
data class WomanWithRef(
	val id: Long,
	val name: String,
	val fieldsId: Long?
)

@Entity
@SqlResultSetMapping(
	name = "WomanWithRef",
	classes = [
		ConstructorResult (
			targetClass = WomanWithRef::class,
			columns = [
				ColumnResult(name = "id", type = Long::class),
				ColumnResult(name = "name", type = String::class),
				ColumnResult(name = "daughters_id", type = Long::class)
			]
		)
	]
)
data class Woman(
	val name: String,
	@OneToMany(cascade = [CascadeType.ALL]) val daughters: MutableSet<Woman> = mutableSetOf(),
	@Id @GeneratedValue(strategy = GenerationType.AUTO) val id: Long? = null
)
//sampleEnd

</xmp>

And we can finally write the query like this:

<xmp class="kotlin-code" theme="darcula"data-highlight-only>
//sampleStart
fun findTypeWithConnectBy(id: Long): Woman {
	val results: List<WomanWithRef> = em.createNativeQuery(
		"""   
			SELECT w.id, w.name, wd.daughters_id
			FROM woman w
			LEFT JOIN woman_daughters wd ON w.id = wd.woman_id
			START WITH w.id = ?1
			CONNECT BY PRIOR wd.daughters_id = w.id
		""".trimIndent(), "TypeWithRefMapping")
		.setParameter(1, id)
		.resultList as List<WomanWithRef>
	return buildGraph(results, id)
}

//sampleEnd
fun buildGraph(queryResult: List<WomanWithRef>, id: Long): Woman {
	val rows = queryResult { it.id == id }
	val firstRow = rows.first()

	val fields = if (rows.size == 1 && firstRow.daughterId == null) {
		mutableSetOf()
	} else {
		rows.mapNotNull { it.daughterId }
			.map { buildGraph(queryResult, it) }
			.toMutableSet()
	}

	return Woman(firstRow.name, fields, id)
}

</xmp>

Using the `buildGraph` function to traverse the query result and reconstruct the root `Woman` object.

If you’re using `HibernateCallback` here’s another way of writing the result mapping: [https://docs.spring.io/spring/docs/2.0.x/javadoc-api/org/springframework/orm/hibernate/HibernateCallback.html][21]

**If you’re not using Oracle** (or some other DB that supports `CONNECT BY`) you can do recursive queries using [Common Table Expression (CTE)][22] to achieve a similar result.

# Is RDBMS right for you?

If you find yourself bending over backwards to make this graph-like queries work, or if you need a query language that will let you express something like:

> _Find all women whose great-grandmother is named Carol and have at least one descendant named Brenda_

Then **maybe you should consider your options beyond RDBMS**. You can take a look at graph databases such as [Neo4j][23] and get familiar with it’s [query language][24]. Or, if you’re not ready to make the jump but want to explore a graph API on top of your relational data you should take a look at [Oracle Spatial and Graph][25].

---- 

_Phew!_ that was a long one… Hope you find it useful!

If you know of a better way of doing this kind of queries I’d love to hear about it, leave me a comment down here👇 or just [ping me on Twitter][26].

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[1]:	http://www.oracle.com/technetwork/java/javaee/tech/persistence-jsp-140049.html
[2]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[3]:	https://en.wikipedia.org/wiki/Directed_acyclic_graph
[4]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[5]:	https://kotlinlang.org/
[6]:	http://projects.spring.io/spring-data/
[7]:	http://www.oracle.com/technetwork/java/javaee/tech/persistence-jsp-140049.html
[8]:	http://hibernate.org/
[9]:	https://www.oracle.com/database/index.html
[10]:	https://www.thoughts-on-java.org/entity-mappings-introduction-jpa-fetchtypes/
[11]:	https://stackoverflow.com/questions/97197/what-is-the-n1-select-query-issue
[12]:	https://vladmihalcea.com/eager-fetching-is-a-code-smell/
[13]:	https://vladmihalcea.com/about/
[14]:	https://vladmihalcea.com/about/
[15]:	https://vladmihalcea.com/hibernate-facts-multi-level-fetching/
[16]:	https://docs.oracle.com/javaee/7/tutorial/persistence-entitygraphs001.htm
[17]:	https://docs.jboss.org/hibernate/orm/5.3/javadocs/org/hibernate/annotations/BatchSize.html
[18]:	http://www.eclipse.org/eclipselink/documentation/2.5/jpa/extensions/q_batch_size.htm
[19]:	https://docs.oracle.com/cd/B19306_01/server.102/b14200/queries003.htm
[20]:	https://developers.redhat.com/promotions/migrating-to-microservice-databases/
[21]:	https://docs.spring.io/spring/docs/2.0.x/javadoc-api/org/springframework/orm/hibernate/HibernateCallback.html
[22]:	https://en.wikipedia.org/wiki/Hierarchical_and_recursive_queries_in_SQL#Common_table_expression
[23]:	https://neo4j.com/
[24]:	https://neo4j.com/developer/cypher-query-language/
[25]:	http://www.oracle.com/technetwork/database/options/spatialandgraph/overview/index.html
[26]:	https://twitter.com/jivimberg