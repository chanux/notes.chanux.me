# Lessons in automation

*Specifically, automating GCP With Terraform*

### Automate all the things

Automating infrastructure (Infrastructure as Code) is now well defined enough.
Use it for the advantages it gives. Thank me later.

Start automating earlier on and always stick to it. Make it the culture.

### Use Service Accounts for all automated access

I have seen people very excited about cooking up images with custom users, keys
for them and whatnot. Guess what, they don't follow best practices in building
the VM images either. Image Update strategies? Pfft!

Use Service accounts for all automated tasks. All good tools support it!

Terraform? yes.

Ansible? yes.

Puppet? yes.

Chef? yes.

### Cut corners

Let's face it. We can all be purists, idealists, perfectionists and all that.
But there are times we **have to** cut corners for good reasons. Just don't let
cutting corners to be a part of the culture. Make it a rare exception.

One startegy is to maintain a corners-cut doc shared among the team. Any corner
that was cut is discussed and documented there upon agreement. Any code
resulted from corners cut but not documented must be *annhilated*, no questions
asked but with a remark in the corners-cut doc.

This doc is also a handy list of things you usually promise yourself to fix
when you have time, which never comes anyway.

### Naming things

The elders were right. It's one of the hardest things in the industry. The
early agreed upon naming conventions will

- eliminate/reduce ambiguity
- allow for a painless onboarding process (because it's easy to read and
  understand)
- make (automation) code look nicer
- imporve maintainability of infra code

Some guidelines.

Decide whether to use environment prefix/suffix on resources.

ex: prod-db-server

If you are using projects to segregate environments (which is a good practice)
you probably don't need this. But some argue that seeing it in the name makes
easier for people who are working with them. Decide what's good for you.

Remember that if you go adding prefix/suffix this will add on cruft on infra
code. Also people from various experience levels will let that leak in to all
abstraction levels making things pretty horrendous.


### Multiple Resource Instances with Lists

Want to generate multiple reource instances off one code block? We can use
[count](https://www.terraform.io/docs/configuration/resources.html#count-multiple-resource-instances)
for that Let's put the varying parts in lists. HOLD ON RIGHT THERE.

> The practice of generating multiple instances from lists should be used
> sparingly, and with due care given to what will happen if the list is
> changed later.

Yeah, that's the Terrafrom documentation. Plus, TF does NOT warn you when you
give a smaller list to work with. It'll just [cycle through the
elements](https://www.terraform.io/docs/configuration-0-11/interpolation.html#element-list-index-).

- It can be difficult to refer to a single resource instance using Terraform
  interpolation. This is especially helpful when creating subsequent resources
  (ex: an instance that go in a certain subnet).
- Overall, difficult to reason about the code.
- Added cognitive overhead in adding/changing variables
- Need a deviation of settings on one resource in a set of resources generated
  with count/list? Move that to a list type variable. In short, lists breed
  more lists.


### Modules

One possible solution to _count/list problem_ is to treat a set of resources
(ex: everything that's needed for a cluster set up like VMs, DNS names etc.) as
one entity and make them in a module. This will definitely not bode well with
traditional way of tampering with individal resources in a set. But if you plan
ahead, it'll be much easier to manage.

Terraform modules that will create multiple different instances of some
resource that are independent from each other is not something I personally
like.

### Links

- [Always be automating](https://queue.acm.org/detail.cfm?id=3197520)
- [Do nothing scripts](https://blog.danslimmon.com/2019/07/15/do-nothing-scripting-the-key-to-gradual-automation/)
