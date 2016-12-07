---
layout: post
title: "Email Google Form daily"
date: 2014-08-21 23:18:14 -0700
comments: true
categories: Google, Productivity
---
Here I'll show you how you can email a Google Form daily, weekly or whatever. I'll achieve this by using [Google App Scripts][1]. Here we go

<!--more-->

1 - Create a Form (If you don't know how maybe this guide is a little bit too advanced for you, anyway you can start [here][2]).

2 - Send this form to your email address using the **Send Form** button. Send it using the **"send form via email"** option, as shown in the picture:

{% img center /images/posts/2014-08-21/SendForm.png 400 'Send Form' %}

3 - Now we need to get that form in HTML. To achieve this we will need the raw email. In GMail you can see it using the **Show original** option in the menu, from there you should copy everything that's enclosed in the `<html>...</html>` tags (including the tags).

{% img center /images/posts/2014-08-21/ShowOriginal.png 250 'Show Original' %}

4 - So we have the HTML but, at least if you obtain it like me, you'll notice that it is encoding as **quoted-printable**. I use [this site][3] to decode it. Make sure you paste your code in the **Encoded** text field and press the **decode** button. Copy this code to your clipboard, we will need it later.

5 - Create a new Script from a Google Spreadsheet *( Tools \> Script Manager... \> New )*. 

6 - In the Script Editor create a new HTML file *( File \> New \> Html file )* and paste your code from step 4. Once pasted remember to save the file. If you're seeing a red asterisk <span style="color:red">_\*_</span> by the name of the file that means it's not saved. 

7 - In the _\*.gs_ paste the following code:

``` javascript
function sendFormEmail() {
    var toEmailAddress = "someone@gmail.com";  
    var htmlMessage = HtmlService.createHtmlOutputFromFile("Name-of-your-HTML-file.html").getContent();
    var subject = "Subject";
    var message = "Some message";
    MailApp.sendEmail(toEmailAddress, subject, message, {
      htmlBody: htmlMessage
    });
}
```

Make sure your replace all the fields with the actual values!

8 - Give it a go and run it once to see if it worked.

9 - Finally go to _Resources \> Current project triggers'_  and create a time driven trigger to run it daily (or weekly, or whatever suits your needs)[^1]

{% img center /images/posts/2014-08-21/Triggers.png 700 'Triggers' %}

9 (option B) - As **an alternative** you can define the triggers in the script itself using code as suggested by [Johannes Schwaninger][4] in the comments. You can do so like this:

``` javascript
function createTimeDrivenTriggers() {
 // Trigger every day at 6 pm.
	  ScriptApp.newTrigger('sendFormEmail')
	  .timeBased()
	  .atHour(18)
	  .everyDays(1) // Frequency is required if you are using atHour() or nearMinute()
	  .create();
}
``` 

10 - Relax and enjoy!

[^1]:	If you’re not seeing the _time driven_ option check that you’re accessing the script editor from a Spreadsheet and not from a Form. Or else just use the code alternative.

[1]:	https://developers.google.com/apps-script/
[2]:	https://support.google.com/docs/answer/87809?hl=en
[3]:	http://www.webatic.com/run/convert/qp.php
[4]:	https://disqus.com/by/johannesschwaninger/