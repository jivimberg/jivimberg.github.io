---
layout: post
title: Writing githooks in Kotlin
date: 2018-07-03 19:45:28 -0700
comments: true
categories: git githook kotlin gradle quality
---

You’re already using Kotlin on your codebase. Maybe, you’ve even migrated to the new [Kotlin DSL for Gradle][1]. Wouldn’t it be nice if you could use Kotlin for your [git hooks][2] too?

<!--more-->

**Well, turns out you can!** Here’s how you do it…

{% img center /images/posts/2018-07-04/captain-hook.png ’Captain githook’ %}

## What do I need?

Git will basically run whatever script you drop on the `.git/hooks` directory. In their words:

> To enable a hook script, put a file in the hooks subdirectory of your `.git` directory that is named appropriately (without any extension) and is executable

So all we need is to be able to execute Kotlin files as scripts. There is a [Kotlin Scripting Support KEEP][3] under definition. But for the time being **we’ll stick with the awesome [KScript library][4] (by [@holgerbrandl][5])** that enables Kotlin scripting on _\*nix-based_ systems.

You can find the details for installing KScript [here][6]. On MacOS if you’re using [Homebrew][7] all you have to do is run: `brew install holgerbrandl/tap/kscript`.

I’ll also be using **Gradle** to automatically install the githook and run the proper validation, but the same can be done with **Maven**.

## The script

As an example I’m going to show how to do a **pre-push client hook** that aborts the push if `grade check` task is not successful. For this I’ve created a file named `Pre-Push.kts`: 

<xmp class="kotlin-code" data-highlight-only>
//sampleStart
#!/usr/bin/env kscript

import java.io.File

println("${Constants.SCRIPT_LOG_TAG} Running oic-form-service pre-push hook")
val hasStashed = stash()
if (hasStashed) {
    println("${Constants.SCRIPT_LOG_TAG} Stashing uncommited changes")
}

val checkExistStatus = runCheck()

if (hasStashed) {
    println("${Constants.SCRIPT_LOG_TAG} Unstashing your changes")
    unstash()
}

val exitValue = when {
    checkExistStatus != Constants.SUCCESS_EXIT_VALUE -> {
        println("${Constants.SCRIPT_LOG_TAG} Gradle check failed. I'm sorry but you can't continue with your push")
        Constants.ERROR_EXIT_VALUE
    }
    else -> {
        println("${Constants.SCRIPT_LOG_TAG} Everything went fine. You can continue with your push")
        Constants.SUCCESS_EXIT_VALUE
    }
}

kotlin.system.exitProcess(exitValue)
//sampleEnd

fun runCheck(): ExitStatus {
    println("${Constants.SCRIPT_LOG_TAG} Running gradle check")
    return "gradle check".runCommandWithRedirect()
}

fun stash(): Boolean {
    val stashOutput = """git stash push --include-untracked -m "stash created by pre-push hook"""".runCommand()
    return stashOutput.firstOrNull() != Constants.NOTHING_TO_STASH_MSG
}

fun unstash() = "git stash pop -q".runCommand()

fun String.runCommand(dir: File? = null): Sequence<String> =
    ProcessBuilder("/bin/sh", "-c", this)
        .redirectErrorStream(true)
        .directory(dir)
        .start()
        .inputStream.bufferedReader().lineSequence()

// Redirecting output and error to stdout
fun String.runCommandWithRedirect(dir: File? = null): ExitStatus =
    ProcessBuilder("/bin/sh", "-c", this)
        .redirectErrorStream(true)
        .inheritIO()
        .directory(dir)
        .start()
        .waitFor()

object Constants {
    const val SCRIPT_LOG_TAG = "Pre-push -"
    const val NOTHING_TO_STASH_MSG = "No local changes to save"
    const val SUCCESS_EXIT_VALUE = 0
    const val ERROR_EXIT_VALUE = -1
}

typealias ExitStatus = Int
</xmp>

The first line is all the _magic incantation_ we need to execute the script. By setting the shebang to `#!/usr/bin/env kscript` we get to use `kscript` as [interpreter for the script][8].

The code after the import is **the actual script**. Those are the lines that are going to be executed as soon as somebody calls the script. _Just as you’d expect with any regular shell script._

In a nutshell this is what the script does:

1. Stash uncommitted changes _if any_[^1]
2. Run code validation (in this case `gradle check`)
3. Unstash possible changes stashed on _step 1_
4. Log outcome and set the proper exit value

The last step is important because **if the script exits to anything other than 0 then git aborts the action** (in this case the push).

### How do I call things from a script?

To do anything useful on your script you’ll probably have to **call some external tool** at some point. In this particular case for example a mix of _git commands_ and _gradle tasks_.

There are 2 ways you can go about this:

1. Either **use a Kotlin/Java library** for the task you’re trying to accomplish (in this example we could use [JGit][9] and [Gradle tooling API][10])
2. Or **call a shell command** directly

While the first approach is more **portable**, it will introduce some dependencies to your script (which fortunately [KScript has great support for][11]). On the other hand the second option is probably **easier to implement** because it’s just using the same commands we use everyday on our workflow.

Since I can assume everybody in my team has `git` and `gradle` installed and in their path **I went for option 2**.

### Running shell commands from Kotlin

We can run shell commands on Kotlin using [`ProcessBuilder`][12], just like we’d do from Java.

In this case I’ve created a `runCommandWithRedirect` extension function that looks like this:

<xmp class="kotlin-code" data-highlight-only>
import java.io.File

//sampleStart
fun String.runCommandWithRedirect(dir: File? = null): ExitStatus {
	    return ProcessBuilder("/bin/sh", "-c", this)
	        .redirectErrorStream(true)
	        .inheritIO()
	        .directory(dir)
	        .start()
	        .waitFor()
}

//sampleEnd
typealias ExitStatus = Int
</xmp>

This function can be called on any String like this:

`"gradle check".runCommandWithRedirect()`

This function will: 

1. Redirect the standard and error output to the one for the current process, in our case that means **the output of the command will be visible on the terminal when the githook is executed**.
2. Set the directory to the passed `dir` parameter, or use the current directory if no parameter is provided.
3. Execute the command, wait for it to finish and return the `ExitStatus`

You can play around with the different `ProcessBuilder` options. In my script above for example I’ve another version of this function called `runCommand` that  **executes the command and returns it’s output as a `Sequence<String>`**.

## Automatic installation

Githooks are great to enforce code quality practices (i.e. _”You can’t push if your coverage is less than 80% “_ 👮). But for the client-side githook to be execute it needs to be in the `.git/hooks` folder which is not versioned. That means that **each developer on your team has to manually install the hook**, which means that you are again, relying on the good memory of your teammates to enforce code quality.

Instead we could use [this trick][13]. We can create a _gradle task_ called _“copy”_ that copies the githook from the `src` folder to the `git/hooks` and removes the file extension in the process.

Then we can make the _“build”_ task depend on this new _”copy”_ task. **The next time the developer runs `gradle build` the githook will be installed**. And as a bonus:  the githook script is now versioned too! [^2]

Here’s how this would look like (using [Kotlin DSL for Gradle][14])

<xmp class="kotlin-code" data-highlight-only>
tasks {
	"copy"(Copy::class) {
		from("src/main/kotlin/io/jivimberg/githook/pre-push.kts") {
			rename { it.removeSuffix(".kts") }
		}
		into(".git/hooks")
	}

	"build" {
		dependsOn("copy")
	}
}
</xmp>

⚠️ Don’t forget to do `chmod u+x Pre-Push.kts` to make the script runnable, otherwise it won’t work.

## What about performance?

Kotlin is a compiled language, so at some point your script will have to be compiled. Fortunately thanks to KScript **this only happens the first time you run the script** and it’s only compiled again if the script changes.

Other than that there’s the JVM startup time which adds **around 200ms of overhead**. Maybe in the future we’ll be able to use [Kotlin Native][15] to compile to native binaries directly and avoid this overhead.

If you want to read more about performance comparison between _Python_ and _Kotlin_ scripts check the [KScript documentation][16].

## Bonus track: testing

Testing Kotlin scripts turned out **not to be so straight forward.** 

[This article][17] suggests using a `runCommand` method similar to the one described above to execute the script and check it’s outputs. Whereas [KScript own tests][18] are written using [assert.sh][19].

Neither approach convinced me. I was just looking for a way of **individually test the functions** in my script **using the same tools I use to test the other parts of my code**.  

So what I ended up doing was moving all the _Pre-Push_ logic to a regular `*.kt` file. And then simply creating a `*kts` Kotlin script that calls my class using the [`//INCLUDE` KScript directive][20]. 

{% img center /images/posts/2018-07-04/testing-githook-kotlin.png ’Testing githook’ %}

The downside is that I know have 2 files for my githook (a `*.kt` and a `*.kts`) but that seems **a small price to pay for being able to easily test my code**.

# Conclusion

Writing githooks in Kotlin is possible and not that hard thanks to [KScript][21]. **You’ll be glad you have tried it out** the next time you have to refactor that _pre-push_ hook.

You can find an **example repository** containing all the code for this blogpost here: [https://github.com/jivimberg/kotlin-githook][22]

<script src="https://unpkg.com/kotlin-playground@1" data-selector=".kotlin-code"></script>



[^1]:	because you want to verify only on the changes that are going to be pushed

[^2]:	And it can even be subject to the same quality standards enforced by the githook itself. INCEPTION!

[1]:	https://github.com/gradle/kotlin-dsl
[2]:	https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks
[3]:	https://github.com/Kotlin/KEEP/blob/scripting/proposals/scripting-support.md
[4]:	https://github.com/holgerbrandl/kscript
[5]:	https://github.com/holgerbrandl
[6]:	https://github.com/holgerbrandl/kscript#installation
[7]:	https://brew.sh/
[8]:	https://github.com/holgerbrandl/kscript#interpreter-usage
[9]:	https://www.eclipse.org/jgit/
[10]:	https://docs.gradle.org/current/userguide/embedding.html
[11]:	https://github.com/holgerbrandl/kscript#declare-dependencies-with-deps
[12]:	https://docs.oracle.com/javase/7/docs/api/java/lang/ProcessBuilder.html
[13]:	https://gist.github.com/KenVanHoeylandt/c7a928426bce83ffab400ab1fd99054a
[14]:	https://github.com/gradle/kotlin-dsl
[15]:	https://kotlinlang.org/docs/reference/native-overview.html
[16]:	https://github.com/holgerbrandl/kscript#what-are-performance-and-resource-usage-difference-between-scripting-with-kotlin-and-python
[17]:	https://proandroiddev.com/testing-kotlin-scripts-42bbbbe09ae5
[18]:	https://github.com/holgerbrandl/kscript/blob/master/test/TestsReadme.md
[19]:	https://github.com/lehmannro/assert.sh
[20]:	https://github.com/holgerbrandl/kscript#ease-prototyping-with-include
[21]:	https://github.com/holgerbrandl/kscript
[22]:	https://github.com/jivimberg/kotlin-githook