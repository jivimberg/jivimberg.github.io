---
layout: post
title: "Spring functional routing"
date: 2018-05-20 00:16:22 -0700
comments: true
categories: spring functional routing router kotlin dsl
---

This post is about the clever tricks you can pull with Spring new **functional routing** and it’s Kotlin DSL.

<!--more-->
{% img center /images/posts/2018-05-19/trainSwitch.jpg ’Train switch’ %}

Spring 5 introduced the [Functional Web Framework][1] and with it the ability to do functional routing. Basically instead of annotating your methods with the good old `@RequestMapping` you can now write functions that go from a `Request` to a `Response<T>` (called `HandlerFunction<T>`). And then use a `RouterFunction<T>` to map which path will end up in which handler.

Now, for the sake of brevity, I won’t talk about all the benefits of this new functional paradigm. Instead I’d like to focus on **some things that can be done with functional routing that were not possible before**.

I have to admit that **at first** I wasn’t sold on the functional routing thing. Why would I want to replace `@RequestMapping` with 2 different functions? Isn’t that more code to achieve the same goal? For comparison this is how a _simple_ RoutingFunction could look like[^1]:

<xmp class="kotlin-code" data-highlight-only>
	fun router() = router {
	    accept(TEXT_HTML).nest {
	        GET("/") { permanentRedirect(URI("index.html")).build() }
	    }
	    "/api".nest {
	        accept(APPLICATION_JSON).nest {
	            GET("/users", userHandler::findAll)
	            POST("/users", userHandler::create)
	        }
	    }
	    resources("/**", ClassPathResource("static/"))
	} 
</xmp>

It’s readable but certainly not as succinct as `@GetMapping("/api/users")`. But **this terseness comes at the price of expressiveness**. Or as [this article on Spring.io][3] puts it:

> The `RouterFunction` has a similar purpose as a `@RequestMapping` annotation. However, there is an important distinction: with the annotation **your route is limited to what can be expressed through the annotation values**.

## Complex routing

I’ll use an example to illustrate some of the things that can be achieved with complex routing. Say I have some data modeling a _résumé_ that contains multiple _sections_. **I want to expose each of this sections as a different REST endpoint**. Underneath we need to handle each call the same way, the only difference is that we’d be processing a different _section_ of data. We could do the routing like this:

<xmp class="kotlin-code" data-highlight-only>
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.io.ClassPathResource
import org.springframework.http.MediaType
import org.springframework.web.reactive.function.server.RouterFunctions.resources
import org.springframework.web.reactive.function.server.router

//sampleStart
	enum class Section(val fieldName: String) {
	PERSONAL_INFO("personalInfo"),
	EXPERIENCE("experience"),
	SIDE_PROJECTS("sideProject"),
	EDUCATION("education"),
}

@Configuration
class Routing {
	@Bean
	fun resumeRouter(handler: ResumeHandler) = router {
	    accept(MediaType.APPLICATION_JSON).nest {
	        Section.values().forEach {
	            GET("/${it.fieldName}", handler.getSectionHandler(it))
	        }
	    }
	}
}
//sampleEnd

@Component
class ResumeHandler {
fun getSectionHandler(section: Section): (ServerRequest) -\> Mono<ServerResponse> =
	        { // get section from data and return response }
}
</xmp>

We can iterate through the enum and create a new mapping for each of the sections with the `GET` function. Furthermore the function `getSectionHandler` can receive the enum as parameter and use it for handling the response instead of having to rely only on the `ServerRequest` context.

Now this is only one of the _tricks_ that can be done with functional routing. Having a [Kotlin DSL][4] means we can do **any kind of scripting we can think of** when defining the routes. As always: 

{% img center /images/posts/2018-05-19/withGreatPower.png ’With great power comes great responsibility’ %}

Abusing this feature would make your routing logic a **tangled mess**, too hard to understand and maintain. So be smart about it.

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>

[^1]:	Source: [kotlin-swagger-spring-functional-template][2]

[1]:	https://spring.io/blog/2016/09/22/new-in-spring-5-functional-web-framework
[2]:	https://github.com/cdimascio/kotlin-swagger-spring-functional-template/blob/master/src/main/kotlin/functional/controllers/Routes.kt
[3]:	https://spring.io/blog/2016/09/22/new-in-spring-5-functional-web-framework
[4]:	https://spring.io/blog/2017/08/01/spring-framework-5-kotlin-apis-the-functional-way#functional-routing-with-the-kotlin-dsl-for-spring-webflux