+++
date = "2014-09-30T20:51:30+02:00"
title = "About me"
slug = "about-me"
url = "about-me"
+++

### TL;DR;

I'm a Swedish dude specialising in making complex problems simple by utilising
software I create in a plethora of languages/tools/frameworks.

Mainly in C#/Go with PostgreSQL/MongoDb as database, hosted on Amazon AWS.

There's a list at the bottom which lists all techs/tools/patterns/languages/etc.
I've worked with and a list of stuff I want to learn.

### 1990 - 1996

I was born, did baby-stuff, grew up, started reading and off we go!

### 1996 - 2005

My very first experience with a computer was a Macintosh running Mac OS 7. Since
I was no older than 6 years I didn't do much in terms of coding. My primary
activities at this time was playing games.

I used Linux a few times during this period, but I was too young to understand
what Linux was, so for me it was just another OS. It could play some games and
that's all I cared about.

### 2005 - 2009

This is where the fun starts, I remember being frustrated by how awful Windows
was in terms of stability, so I decided to embark on a journey to find something
different. After some research I found Ubuntu, which was a quite nice
experience, but yet again I got frustrated since it didn't do the things Windows
did, mainly running games. So back to Windows I went... Then back to Ubuntu
again. I did this a few times, but then I got kind of stuck in Ubuntu for a
while, having left the gaming scene for a while. So, as I started using Ubuntu
more and more, I realised that I needed other than games to keep me entertained.

I remembered that I've taken a course in webdesign back in elementary school, so
I thought to myself, why not make a website? And off I went, researching and
started creating something resembling a website. This was done in pure HTML and
CSS, no Javascript, no tools to generate HTML. This is what sparked my interest
in programming, since I thought having to type all that HTML over and over was
cumbersome, so I started investigating in solutions to my problem, which in this
case was copying and pasting the menu on each page. So off to IRC I went,
describing my problem and people suggested I try this thing called PHP. Having
no idea what a programming language was and absolutely no idea of how
http-servers worked, but an idea of what I wanted, I started doing some more
research. After a while I had some PHP scripts which could assemble a page based
on a content page, a header and a footer, and thus, my first website was born.
I was hooked. I wanted more!

So I did some more research, I asked on IRC some more, what else could I use
this newfound knowledge for? Someone suggested I create some kind of dynamic
website, something where people could leave me a message. The idea of coding
a guestbook was created. So I figured I need to store this somewhere and after
some research I figured I need a database. So what to use? Well, at this time
people used PHP along with MySQL, so that's what I used.

Fast forward some time, I've created my hundredth website/guestbook/blog clone,
each time making some kind of improvement. I started using frameworks, mainly
CodeIgniter. It was around this time (2006) I started my gymnasium school.
I choose a major which focused on programming and digital technology (How 
computers work and how to build them) and there I would be thaught two different
programming languages, PHP and C#. Since I already knew PHP I looked forward to
learning that, but since that was thaught at the end of the programme I had to
suffer through the hours of learning C#, ugh. At this time I *hated* everything
Microsoft, for some odd reason. It was also my first statically typed language, 
which was a huge shock for me. Having all of these types all around me when it
didn't really matter! Oh well, I suffered through and started doing some more
research outside the material thaught in school. I discovered you could do web
stuff in C# as well (We focused mainly on creating console applications, since
it was beginners courses), using ASP.NET. But oh, using PHP was so much easier!

The time came to find some kind of trainee work (Some programmes in Swedish
education have several weeks of mandatory trainee work), so I found a local
company called Entergate. They specialise in making survey tools, in ASP.NET.
Since I didn't really know what ASP.NET was, I had to learn it. This was my
first experience in learning something while producing something, but I didn't
stop there, I wanted something more challenging, something *better* than
ASP.NET Webforms. This was around the time Scott Guthrie with friends started
making ASP.NET MVC, so that's what I wanted to use. Off I went and started
producing stuff in ASP.NET MVC. Not something useful, but it was something.
Since Entergate is a Microsoft-shop, they used Microsoft SQL Server, so that's
something I picked up as well.

During spring 2009 I graduated, an experience met with both joy and sadness,
realising that I had no idea of what I wanted to do with my life, until some
dude off the internet said he wanted to import me to London. Who at the age of
19 would say no to getting paid to do what he loves to do and live in London?
Well, probably some, but not me! Off I went!

Then I arrived in London (Well, Stanstedt airport), having no idea of what to
expect, heck I hadn't even seen this dude in a photo! Yet here I was, in a
foreign country, talking English with people who only knew English. No Swedes to
be seen!

But there he was, Ayo himself! My future employer for a while.
He owned a company called DesignSquad, which did small websites, some printing
and other design/computer-related stuff. It was fun, we made websites primarly 
in ASP.NET MVC along with Microsoft SQL Server as the database. We also used my
first ORM, LINQ to SQL. But all fun things must come to an end. We had some
fiesty discussions on how to do stuff and the least I could say was that we
disagreed. Looking back at it, it was me being immature and a bit too picky
about things. We did part as friends though.

So it was time to head back to Sweden...

### 2010 - 2011

...and start finding a job. This was a brutal experience, but at the same time
a very easy one. It was quite easy to find a job and get it, but the very
thought of having to find a job was weird, why did I, the best coder out there
need to *find* a job, the job should find me. Oh well, I managed to score a job
at Industritorget Sweden AB, as their new star developer! My job was to convert
the existing website from Classic ASP to ASP.NET. There was another developer
already employed to do this task, but management thought reinforcements where
needed and that was me.

The existing website was made with Classic ASP, something I'd never seen before.
It did have something I had seen before though, it used MySQL as the database
engine. The other developer had already begun documenting and figuring out how
to structure and design the new website. So we begun writing it in C#, with
Entity Framework, in ASP.NET Webforms and using SQL Server as the database.
But since we where using the very first version of Entity Framework, which
didn't have code-first, we relied quite heavily on having it generate the model
for us, which turns into a huge mess whenever you somehow change the model in
code, by adding fields, methods, etc. In short, it was horrible trying to
construct a decent domain model using Entity Framework. Since this slowed down
development by a huge amount, management decided it was time for a change, so
within seconds I was promoted to project lead, a position I'd never held before
and in retrospect, something I wasn't mature enough to handle.

This led to the other developer saying good bye and he left the company. So
there I was, alone, converting a Classic ASP application into ASP.NET. A task
I wasn't prepared handling by myself, which led to development grinding to a
halt. So management re-allocated my knowledge into the existing website,
creating new features in Classic ASP. I also got the responsibility of taking
care of the existing server installing, which was handling e-mail, backup, etc.
running on Windows Small Business Server. Something I had no experience in. 
Shortly after this I decided to leave this company, since I was doing something
I wasn't hired to do nor had any experience in. It's always fun to learn, but
learning must be done within the comfort zone if it's about stuff already in
production.

So, back to the drawing board and time to find another job. Which roughly took
about 3 monts...

### 2011 - 

...and then I started my current job as a developer at Bosbec AB.

__More to come...__

### Contact

If you're interested in contacting me, please do so via
[Twitter](https://twitter.com/hagbarddenstore),
[e-mail](mailto:hagbarddenstore@gmail.com) or find me on
[IRC](irc://freenode.org/##csharp) where I go by the name Kim^J.

### A pile of tags

A huge compilation of stuff I've used in past projects in alphabetical order:

<ul class="list-inline">
<li class="text-primary">Ansible</li>
<li class="text-primary">ASP.NET MVC</li>
<li class="text-primary">ASP.NET Webforms</li>
<li class="text-primary">Amazon AWS</li>
<li class="text-primary">Amazon AWS Auto-Scaling Groups</li>
<li class="text-primary">Amazon AWS Cloudformation</li>
<li class="text-primary">Amazon AWS EC2</li>
<li class="text-primary">Amazon AWS ELB</li>
<li class="text-primary">Amazon AWS RDS</li>
<li class="text-primary">Amazon AWS Route53</li>
<li class="text-primary">Amazon AWS S3</li>
<li class="text-primary">Bash</li>
<li class="text-primary">C#</li>
<li class="text-primary">C/C++</li>
<li class="text-primary">Caliburn.Micro</li>
<li class="text-primary">Classic ASP</li>
<li class="text-primary">Cloud init</li>
<li class="text-primary">CodeIgniter</li>
<li class="text-primary">CQRS</li>
<li class="text-primary">CoreOS</li>
<li class="text-primary">Django</li>
<li class="text-primary">Docker</li>
<li class="text-primary">Domain-Driven Design</li>
<li class="text-primary">Eclipse</li>
<li class="text-primary">Elasticsearch</li>
<li class="text-primary">Enterprise Service Bus</li>
<li class="text-primary">Entity Framework</li>
<li class="text-primary">Event-Driven Architecture</li>
<li class="text-primary">Event-store</li>
<li class="text-primary">Fedora</li>
<li class="text-primary">Fleetd</li>
<li class="text-primary">Git</li>
<li class="text-primary">Gearmand</li>
<li class="text-primary">Golang</li>
<li class="text-primary">Graylog</li>
<li class="text-primary">Hugo</li>
<li class="text-primary">Java</li>
<li class="text-primary">Javascript</li>
<li class="text-primary">Jekyll</li>
<li class="text-primary">Jetbrains IntelliJ</li>
<li class="text-primary">Jetbrains PyCharm</li>
<li class="text-primary">Jetbrains Resharper</li>
<li class="text-primary">Jetbrains RubyMine</li>
<li class="text-primary">Jetbrains Teamcity</li>
<li class="text-primary">Jetbrains WebStorm</li>
<li class="text-primary">Jetbrains YouTrack</li>
<li class="text-primary">Laravel</li>
<li class="text-primary">Linux</li>
<li class="text-primary">Mac OS X</li>
<li class="text-primary">Markdown</li>
<li class="text-primary">Microsoft MSMQ</li>
<li class="text-primary">Microsoft SQL Server</li>
<li class="text-primary">Microsoft Visual Studio 2005</li>
<li class="text-primary">Microsoft Visual Studio 2008</li>
<li class="text-primary">Microsoft Visual Studio 2010</li>
<li class="text-primary">Microsoft Visual Studio 2013</li>
<li class="text-primary">Microsoft Windows 2000</li>
<li class="text-primary">Microsoft Windows 7</li>
<li class="text-primary">Microsoft Windows 8</li>
<li class="text-primary">Microsoft Windows 98</li>
<li class="text-primary">Microsoft Windows Server 2003</li>
<li class="text-primary">Microsoft Windows Server 2008</li>
<li class="text-primary">Microsoft Windows Server 2008R2</li>
<li class="text-primary">Microsoft Windows XP</li>
<li class="text-primary">MongoDb</li>
<li class="text-primary">MySQL</li>
<li class="text-primary">NServiceBus</li>
<li class="text-primary">Netbeans</li>
<li class="text-primary">Objective-C</li>
<li class="text-primary">Oracle DB Express</li>
<li class="text-primary">PHP</li>
<li class="text-primary">PostgreSQL</li>
<li class="text-primary">Python</li>
<li class="text-primary">RabbitMQ</li>
<li class="text-primary">RavenDB</li>
<li class="text-primary">Rebus</li>
<li class="text-primary">Ruby</li>
<li class="text-primary">Scala</li>
<li class="text-primary">SQLite</li>
<li class="text-primary">SuSE Linux</li>
<li class="text-primary">Sublime Text 3</li>
<li class="text-primary">Systemd</li>
<li class="text-primary">Svn</li>
<li class="text-primary">Teamcity</li>
<li class="text-primary">Textile</li>
<li class="text-primary">Topshelf</li>
<li class="text-primary">Twitter Bootstrap</li>
<li class="text-primary">Ubuntu</li>
<li class="text-primary">VB.NET</li>
<li class="text-primary">VBScript</li>
<li class="text-primary">Vim</li>
<li class="text-primary">WCF</li>
<li class="text-primary">WPF</li>
<li class="text-primary">Wordpress</li>
<li class="text-primary">Zsh</li>
</ul>

Looking forward to learn more about:

<ul class="list-inline">
<li class="text-primary">FoundationDB</li>
<li class="text-primary">The Spotify architecture</li>
<li class="text-primary">Project management</li>
<li class="text-primary">DynamoDB</li>
<li class="text-primary">Apache Cassandra</li>
<li class="text-primary">Jenkins</li>
<li class="text-primary">Redis</li>
</ul>

### Books

A collection of books I've read during the past years.

#### Clean Code: A handbook of agile software craftmanship

ISBN-13: 978-0132350884

#### The Clean Coder: A code of conduct for professional programmers

ISBN-13: 978-0137081073

#### Domain-Driven Design: Tackling complexity in the heart of software

ISBN-13: 978-0321125217

#### Patterns of Enterprise Application Architecture

ISBN-13: 978-0321127426

#### The art of UNIX programming

ISBN-13: 978-0131429017

#### An introduction to programming Go

ISBN-13: 978-1478355823

#### CQRS, the example

ISBN-13: 978-1484102879

#### Remote: Office not required

ISBN-13: 978-0091954673

#### Design patterns: Elements of reusable object-oriented software

ISBN-13: 978-0201633610

#### Implementing domain-driven design

ISBN-13: 978-0321834577

#### Scrum: A breathtakingly brief and agile introduction

ISBN-13: 978-1937965044

#### The expert beginner

ISBN-13: 978-1619849969

#### The mythical man month: Essays on software engineering

ISBN-13: 978-0201835953

#### Mastering Regular Expressions

ISBN-13: 978-0596528126

#### Agile Principles, Patterns, and Practices in C\# 

ISBN-13: 978-0131857254

#### The Docker Book: Containerization is the new virtualization

ISBN-13: 978-0988820234