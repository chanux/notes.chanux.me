# Flexible Terraform

## Overview

When the days were old and simple, we created simple modules with a few
variables and created a bunch of resources. If we wanted multiple instances of
a resource, we used `count`s. Multiple instances of
a resource with some custom infomtion? `list`s were the go to.

Then we learned about [the perils of
lists](https://faun.pub/terraform-deleting-an-element-from-a-list-cb5bdadc8bbd),
the hard way.

Our simple modules with a dozen variables grew into requiring a few dozens of
varaibles. We soon lost flexibility in complexity.

However, not all hopes are lost. Terraform introduced more features to deal
with the naturally increasing complexity. These, combined with a bit of
discipline and a set of good rules of thumb we may be able to claw back some
flexibility while arguably reducing complexity.

At my day job, I was introduced to
[aztfmod](https://github.com/aztfmod/terraform-azurerm-caf), an open source
Terraform module maintained by a team at Microsoft, providing an opinionated,
yet flexible implementation of their Cloud Adoption Framework for Azure.

Looking at aztfmod, I have learned a great deal about managing the inevitable
complexity and keep things flexible still. This write up is to note down the
main ideas of this endeavour.

## Choose Maps

As mentioned in the overview, lists can lead us to unsavory outcomes. But the
need for creating groups of resources don't just go away. Hence, choose maps to
represent groups of objects.

```
virtual_networks = {
  primary = {
    name                = "primary"
    location            = "southeastasia"
    resource_group_name = "my-rg"
    address_space       = ["10.0.0.0/16"]
    dns_servers = [
      "10.0.0.4",
      "10.0.0.5",
    ]
  }

  just_for_fun = {
    name                = "example-network"
    location            = "southeastasia"
    resource_group_name = "my-rg"
    address_space       = ["10.1.0.0/16"]
    dns_servers = [
      "10.0.0.4",
      "10.0.0.5",
    ]
  }
}
```

So yeah, choose not just maps. Choose maps of objects!

This makes your config more readable and it helps separating code and config.
On top of that, map keys provide an interesting benefit!

```
subnets = {
  first = {
    name                = "first-snet"
    address_prefixes    = ["10.0.1.0/24"]
    virtual_network_key = "primary"
  }

  zweite = {
    name                = "zweite-snet"
    address_prefixes    = ["10.0.2.0/24"]
    virtual_network_key = "primary"
  }

  fun_subnet = {
    name                = "fun-snet"
    address_prefixes    = ["10.1.1.0/24"]
    virtual_network_key = "just_for_fun"
  }
}
```

Did you see how I used the keys from `virtual_networks` map to reference
a virtual network from a subnet configuration object? You can use this idea and
link configuration objects!

```
resource "azurerm_virtual_network" "main" {
  for_each = var.virtual_networks

  name                = each.value.name
  address_space       = each.value.address_space
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_virtual_network.main[each.value.virtual_network_key].resource_group_name
  virtual_network_name = azurerm_virtual_network.main[each.value.virtual_network_key]
  address_prefixes     = each.value.address_prefixes
}
```

In scaling up and/or down, you can create 0, 1 or n number of resources by
just updating configuration!

Also, did you notice that the virtual network and subnet configurations are
similar to the relevant Terraform resource configuration? That's not by
mistake. This way, your module interface does not become another new thing
figure out.  And regarding the documentation, folks behind Terraform already
wrote most of it!

Enough with the 5 star comments. Let's get to the 2 star ones.

One downside to using maps is that it can feel quite verbose. In some cases,
the map keys might feel supefluous and you may be drawn to *sets of objects*.
Keep in mind that you CAN NOT use sets of objects with `for_each`

One important rule of thumb to follow is to not give "significance" to map
keys. Let me explain! Do not use map keys in any parameter in your resource
where a change in key would lead to destroy/create of your resource!  So,
please make your map key names meaningful but DO NOT let them have any
significance in your resources!

## A bit of magic

While this way of doing things make configuration readable and close to
Terraform resource definitions, we may be pushing some complexity into the
module code, in some cases.

For example, to resolve object relationships based on available info (ex: map
keys), sometimes you need to be comfortable with [`for`
expressions](https://developer.hashicorp.com/terraform/language/expressions/for)

When you are building complete modules using these ideas, things become highly
dynamic and you are destined to come across cases where you have to use nested
loops. I hope [this
guide](https://gist.github.com/chanux/e9ebabb46169b9d2c46c331f56da4800) will
help demistifying nested loops!

## To try or not to try

In aztfmod, they do not use strict type definitions. Instead, they heavily use
`try` or `coalesce` to gracefully resolve input parameters. However,
I personally prefer types, even though I do see some cons to it.

- If you have two layers of modules (a module with a submodule), and have to
  pass down values as is,  you may have to repeat your type definitions and it
  can get tedious.
- The validation system is not good enough for nicely handling some complex
  validations/checks.
- Multiple optional parameters can really get you with
  [typos](https://gist.github.com/chanux/8afa8c25bc198187eee892ab54063f3c).

However, I really like getting the type system to work for me (set defaults,
ensure type adherence) and the fact that it clearly tells the user what's
expected.

As an aside on `try`, I once got bamboozled because I used `null` to
incorrectly emulate the error case. Check [this
gist](https://gist.github.com/chanux/6de8bcdfeea327240776b7e4af72eb69) to
witness my naivete and not repeat my mistakes!

To conclude, I have not had to write modules of aztfmod scale or complexity.
Hence I have survived with type definitions so far! So pick what's right for
you with experimentation!

PS: Thanks [Laurent Lesle](https://github.com/LaurentLesle) for the biggest
opportunity to learn and grow in 2023! The general sense of confidence you gave
in getting into an unfamiliar way of doing things and your mentorship was
a pillar for the success in the effort that taught me all this.
