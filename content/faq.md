Title: Frequently Asked Questions
Path-Alias: /faq
Entry-Type: sidebar
Date: 2018-04-30 17:01:50-07:00
Entry-ID: 374
UUID: db73553b-e046-47f4-9ee3-8749b7daab2c

.....

## General

### What is Publ, anyway?

It is a content management system (CMS) for publishing to the web. Think of it as filling
a similar niche as Movable Type or Wordpress, only with a focus on heterogenous
content and flexibility.  For [my own personal site](http://beesbuzz.biz/) I need to be able to manage
comics, music, art, photography, a blog, and who knows what else as uniformly
as possible, and I really want RSS/Atom feeds to be the norm again.

Pretty much I want to focus on the "C" in "CMS."

The name, incidentally, is short for "Publish."

### Why not just use Wordpress/Movable Type/Jekyll/Pelican/...?

I actually have played around with a lot of different CMSes, and have mostly used
MT for running my sites in the past. Don't get me wrong, a lot of these CMSes have
a lot going for them! But none of them really fit into the niche I'm looking for,
with this particular combination of features:

* Allowing multiple templates for different parts of the site
* Ensuring the ability to reorganize content (or import content from other systems) and have permalinks remain valid
* Having MVC-style routing rules that allow for future expansion
* Keeping pages and their content together
* Providing dynamic image renditions which are:
    * CDN-friendly
    * Template-driven
    * Multi-resolution/high-DPI-aware
    * Not prone to denial-of-service attacks
* Stable pagination (i.e. an archive page's link should always point to the same content regardless of when a search engine indexed it)

I had ended up hacking a lot of this functionality into my Movable Type templates
but as I mentioned on [the first blog entry](325), this got incredibly unwieldy and difficult!

### What does the UI look like?

It actually doesn't have one! And this is by design. I don't want to force people
into a specific content management mindset. The software primarily indexes separate
content files, and uses that to present them in a way appropriate to the content
in question.

When I write a post for this I'm writing it in [my text editor of choice](http://sublimetext.com)
and checking it into the main software's [GitHub repository](http://github.com/fluffy-critter/Publ) and pushing it to the server. But someone else might want
to upload the files manually via FTP, and someone else might want to use an online
file editor like [codeanywhere](https://codeanywhere.com) or map their server's content directory with [sshfs](https://en.wikipedia.org/wiki/SSHFS) or any other number of things that suit their
particular needs best. And of course a single mechanism might not even be useful
for a single site — republishing content would be best handled
by other tools, like a [cron job](https://en.wikipedia.org/wiki/Cron) that pulls an external RSS feed,
for example.

My *intention* is that there will eventually be a built-in content editor with some
sort of configurable access rules, but that's more of a long-term goal rather
than a necessity for Publ's initial release.

### Great, how do I install it?

Right now there's a [very basic Dreamhost HOWTO](/dreamhost)
(which might apply to other shared hosting providers using [Passenger](https://www.phusionpassenger.com))
but there's definitely a lot of work to be done in the documentation area. It's also fairly straightforward to
deploy on [Heroku](http://heroku.com).

The [files for this site](http://github.com/fluffy-critter/publ.beesbuzz.biz) are already configured for
deployment on both Dreamhost and Heroku. So, you can use it as a reference point already.

## Design

### What is it written in?

Publ is written in Python (I'm specifically developing against 3.6, although it should be compatible with
any version past 3.4, and with some work could probably work with 2.something),
using the [Flask](http://flask.pocoo.org) framework, and the [Peewee ORM](https://peewee.readthedocs.io). For Markdown
processing it's using [Misaka](http://misaka.61924.nl).

#### Why Flask (and not web.py/pyramids/...)?

Because it's easy to get started with and it's what I know, and provides some
pretty decent flexibility while also having a nice ecosystem of modules that I
might be using in the future. This decision isn't set in stone, though, and the
number of specific dependencies on Flask are pretty minimal.

#### And why Peewee (and not SQLAlchemy/raw SQL/MongoDB/...)?

Because it's easy to get started with and handles the actual use cases for the
site pretty well. The database itself is just a disposable content index (in fact,
the way Publ currently does a schema upgrade is by dropping
all its tables and re-scanning the content files). I didn't see any need for
anything more "proper" when the only requirements are a glorified key-value store
with some basic indexing; Publ treats the filesystem itself as the ground truth database.

This decision is also something I'd be willing to revisit.

#### And Misaka?

It's a pretty good Python binding to the [Hoedown](https://github.com/hoedown/hoedown)
Markdown parser, with enough flexibility for the extensions I want to add.
It supports (most)
GitHub-flavor markdown and [MathJax](http://mathjax.org) out of the box, and its
design allows adding further syntax hooks for the supported tokens. The downside
is that it's not feasible to extend it with custom tokens but so far I haven't
really found any need for that.

Again, this decision isn't set in stone.

### Why didn't you use PHP/Haskell/Go/Ruby/...?

I tend to dislike PHP for many reasons, both with the language itself and with
its ecosystem.
While I wouldn't go so far as to say that PHP-the-language is irredeemably bad,
there are some
pretty fundamental problems with its security model that make it somewhat
undesirable. Also, setting up a flexible
request routing mechanism is way too varied and error-prone with PHP, and I haven't found any
PHP templating systems I'm happy with.

As far as other languages go, one of my primary concerns was making it deployable
in as many places as possible, ideally being runnable on Dreamhost shared hosting,
which imposes pretty strict limitations on choices of language and runtime memory
requirements; you're pretty much limited to PHP, Python, and Ruby, and my experience
is that even basic Ruby apps end up consuming far too much memory for Dreamhost
shared hosting.

Also, it helps to be in a language I actually know, and while I'm far
from a Python expert, I know it way better than any of the other languages people
suggest for this purpose!

I also like the Python ecosystem for this stuff; Jinja2 templating is particularly
well-suited to the way I think about page render logic, for example, and is also
compatible with plenty of HTML authoring tools.

All that said, I'd love to see other people design similar systems using whatever
choice of platform they prefer — at the very least, it amuses me to think that
someone might make something that is "Publ-ish."

(I *may* have had that pun in mind when I chose the name...)

## Performance

### This site seems kind of slow...?

At present, the main performance issue is that if the Python process dies, it
takes quite a bit
of time for the Passenger WSGI wrapper to restart it on the next page request.
Unfortunately there's not a lot that can be done there, but this is less of an
issue for sites which actively serve traffic. Fortunately, once it's up and running
everything seems to run pretty smoothly.

Also, the first time a large image set gets rendered out it can take some time;
I have [some ideas on how to improve that](https://github.com/fluffy-critter/Publ/issues/53)
although it's only a one-time cost per template and image so I'm not *too*
worried about it just yet.

## Interoperability

### Why don't you support ActivityPub?

I do plan on that being part of the system in the long term, but it's not
really necessary for any of my current requirements. Being able to subscribe to
long-form content is already well-handled by syndication feeds like Atom and RSS,
and ActivityPub is focused more on doing instant push updates for short-form content.

However, I do have plans for supporting private/friends-only content, and
ActivityPub fits nicely into that world! I had spent a lot of time trying to
design mechanisms of doing something similar with OAuth/OpenID authentication
tied to single-subscriber Atom feeds, but ActivityPub is much more suited to
that sort of thing, so that might be the direction I go in there. (I still prefer
the OpenID model I'd worked out in my head, but given that one of my main goals
is open standards interoperability, and everyone's focusing on ActivityPub these
days, it seems silly to not at least consider ActivityPub!)

### Okay, so, how can I help?

Glad you asked!

Currently my focus is on getting the core functionality in place. The main thing
left to do at this moment is image renditions, which is incredibly important to
me and I have a very specific design in mind.

Where I could use the most help right now:

* Building example templates/themes for people to use
* Improving the deployment mechanism (especially for targets like Heroku or Google App Engine)
* Improving the documentation for everything (in particular there needs to be some
    sort of "quick start" guide to get people going with writing/using templates, and
    explaining how the heck to use Publ in the first place!)
* Improving the code quality — currently all testing is via ad-hoc smoke tests, and
    I'm still relatively inexperienced in Python so I'm sure a lot of places where the
    code could be better/cleaner/more Pythonic
* Making the Publ site look nicer in general

I also have a [rather large list of to-do items](http://github.com/fluffy-critter/Publ/issues),
most of which are low priority for me. But if there's something you want to help on, please,
by all means, do so!