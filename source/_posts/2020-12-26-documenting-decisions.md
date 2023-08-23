---
layout: post
title: "Documenting Decisions"
date: 2020-12-26 13:51:06 -0800
comments: true
categories: documentation architecture culture
---

It’s Monday morning. You’re sitting at your desk with your steaming cup of Joe, ready to sink your teeth into that new feature you have to develop. The `git pull` downloads months worth of changes, and you dive into the code. Piece by piece, you start building a mental model of the system, trying to make sense of the different components. But something doesn’t feel right. Why was it built this way? It feels weird, it feels so obviously wrong, so poorly designed, so suboptimal.

You realize you need help. Whoever wrote this mess should be able to provide some context. You run `git blame` and your own name hits you in the face like a brick. You start thinking that maybe it’s no so wrong. That you probably had your reasons. If you could only go back in time and ask your past self…

<!--more-->

## Architecture Decision Logs

Good developers write code that is easy to understand and use comments to provide additional context. Great teams write documentation explaining how the system is designed and how it is supposed to work. But even if you are blessed with both, there’s still a piece that is usually missing. **Something that can answer the question: _How did we end up here?_.** Something that can provide context on why the system was designed this way, on what other options were considered and rejected, on why we picked this particular technology or pattern.

That’s exactly what an [Architecture Decision Log (ADR)][1] is for. 

> An **Architecture Decision Record (ADR)** is a document that captures an important architectural decision made along with its context and consequences.

> An **Architecture Decision Log (ADL)** is the collection of all ADRs created and maintained for a particular project (or organization).

An Architecture Decision Log can help us capture the context, motivations, and assumptions behind a decision. We are basically doing a brain dump of all the things that were considered before making a final call on something.

{% img center /images/posts/2020-12-26/architecture.gif 500 %}

If one thing is constant about developing software is change. New features are requested, the app grows and it has to support an increasing number of requests, people leave the team and new developers join. By keeping an Architecture Decision Log, we capture the thought process that goes into a decision, **so that future maintainers can understand why something is the way it is, and use this information to evaluate new changes.**  Maybe an assumption made about how users would use the app turned out not to be true. Or perhaps a requirement about the size of stored data has changed, and the existing database can’t scale accordingly.

And that’s not all! ADLs can also provide information about the path not taken. We can document what other alternatives were considered and why they didn’t fly. If some possible solution was initially considered, chances are it’ll come up again as a suggestion in the future. By documenting the research, we avoid new team members wasting their time going down the same rabbit holes explored in the past. Or at least we provide a starting point for a potential re-evaluation.

## The Template

There are a bunch of templates you can follow in this [GitHub repo][2]. But to be honest, the template doesn’t really matter as much as actually writing them. I usually go with something like this:

* **Information:** This is like a header where you can include the date, the topic, and who’s writing. Most of this metadata can be obtained from the history if you’re versioning your documentation (as you should), but I think it’s worth repeating it at the start of the document for clarity.
* **Problem Context:** A brief description of what you’re trying to solve and why. _Don’t forget the why_, it might be obvious to you at the time of writing, but it won’t be to someone else in a couple of months/years. 
* **Details:** This is usually the longest part. Here you can describe all the alternative solutions explored and detail the pros and cons of each approach.
* **What was decided:** In this section, you document the final decision as well as the rationale on why one option was picked over the others. Usually, you’ll be making some guess or assumption about how the system will evolve in the future, make sure to include those too.

If you’re curious about what they look like, you can see some ADR examples [here][3].

## Tooling

You can start your Architecture Decision Log as a new section of your documentation. **I favor keeping documentation as close to the code as possible. Ideally, in the same repository.** Why? Because it’s easier to keep them in sync that way. For example, you can submit your code and documentation changes as part of the same PR. It also makes it more discoverable, as searching for a term in the IDE will bring up results on both code and documentation.

Whatever tool you use, make sure your documentation is searchable and, above all, easy to edit. Ideally, it should also be versioned. I think [MkDocs][4] fits the bill pretty well, and it’s easy to setup. 

## How to write a good ADRs

Some advice on how to write a good Architecture Decision Record:

1. **Write everything down, even if it’s obvious.** The document you are writing might need to be read by somebody new to the team years from now. Try to paint a complete picture.
2. **It’s not just about the technical stuff.** Many factors that contribute to a design decision. It might be the team size, the team knowledge of a specific technology or some deadline that needs to be met. 
3. **Keep it honest.** Engineering is about cutting corners. There’s no shame in taking shortcuts, so don’t try to hide it. If some decision was taken because of time constraints or the team resorted to a technology only because it’s what they know best, then better to be upfront about it.
4. **Keep it short or include a TL;DR.** Keep it easily digestible. If you are including all of the research done, you might want to consider adding it as an appendix. If the document is too long, make sure there’s a good summary on the top so that somebody not interested in the details can still get an overview of the decision.
5. **ADRs are immutable.** You’re capturing a snapshot of a decision, so there’s no need to update ADRs after time has passed. If new things come up, you can always create a new document and link it to the previous one.
6. **You can write ADRs even if you don’t have code.** I had tasks that ended up being just an ADR. Maybe you start exploring some performance improvement only to realize it is not feasible. Instead of just scrapping all the code, make sure to include an ADR detailing what the idea was, and why it didn’t succeed. That way, the next time somebody suggests it, they can learn from your attempt instead of falling into the same pitfalls.
7. **Make it fun.** Just because it’s documentation doesn’t mean it has to be boring. Tell a story. Make it fun! include pictures, diagrams, memes. Use emojis! 😄

## The future (hopefully)

I believe there’s plenty of room for improvement and innovation in the area of documentation tooling. **One thing I’d love to see are smart ADRs that would trigger a notification when one of the assumptions documented breaks.** For example, let’s say your team chose to keep some information in memory for every request because the payload size is expected to be small. They made the call, implemented the code and wrote the appropriate ADR. It’d be great if they could also include a metric as part of the documentation that would monitor that the assumption holds. That way, the team would get notified if, at some point, the expectation is no longer valid. The alert would link to the ADR including context about what system decisions are affected by this violation, and what other facts need to be considered if a change is required.

---- 

 {% img right-fill /images/signatures/signature2.png 200 ‘My signature’ %} 

[1]:	https://github.com/joelparkerhenderson/architecture_decision_record
[2]:	https://github.com/joelparkerhenderson/architecture_decision_record#adr-example-templates
[3]:	https://github.com/joelparkerhenderson/architecture_decision_record/tree/master/examples
[4]:	https://www.mkdocs.org/