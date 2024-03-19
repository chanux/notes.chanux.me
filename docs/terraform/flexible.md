# Flexible Terraform

## Overview

When the days were old an simple, we created simple modules with a few
variables and created a buch of resources. If we wanted multiple instances of
a resource we used `count`s. If we wanted to create multiple instances of
a resource with some custom info we used `list`s.

Then we learned about [the troubles of
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
complexity and keep things flexible still.

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
    dns_servers         = ["10.0.0.4", "10.0.0.5"]
  }

  just_for_fun = {
    name                = "example-network"
    location            = "southeastasia"
    resource_group_name = "my-rg"
    address_space       = ["10.1.0.0/16"]
    dns_servers         = ["10.0.0.4", "10.0.0.5"]
  }
}
```

So yeah, choose not just maps. Choose maps of objects!

This makes your config more readable, helps separating code and config and map
keys provides and interesting benefit!

```
subnets = {
  first = {
    name                = "first-snet"
    address_prefix      = "10.0.1.0/24"
    virtual_network_key = "primary"
  }

  zweite = {
    name                = "zweite-snet"
    address_prefix      = "10.0.2.0/24"
    virtual_network_key = "primary"
  }

  fun_subnet = {
    name                = "fun-snet"
    address_prefix      = "10.1.1.0/24"
    virtual_network_key = "just_for_fun"
  }
}
```

Did you see how I used the keys from virtual_networks map to reference
a virtual_network from a subnet configuration object? You can use this idea and
link configuration objects! if you noticed, the virtual network and subnet
configurations are similar to the relevant terrafrom resource!

In scaling up and/or down, you can create 0, 1 or n number of resources with
just updating configuration!

One downside to using maps is that it can feel quite verbose. In some cases,
the map keys might feel supefluous and you may be drawn to *sets of objects*.
Keep in mind that you CAN NOT use sets of objects with `for_each`

One important rule of thumb to follow is to not give "significance" to map keys. Let
me explain! Do not use map keys in any parameter in your resource where
a change in key would lead to destroy/create of your resource! 

So, please make your map key names meaningful but DO NOT let them have any
significance in your resources!

## A bit of magic

While this way of doing things make configuration readable and close to
terraform resouce definitions, we will be pushing some complexity into the
module code. 

TODO: Add example resource referennce code

For example, to be able to link objects based on map keys, you need to be
comfortable with [`for`
expressions](https://developer.hashicorp.com/terraform/language/expressions/for)

When you are building complete modules using these ideas, things become highly
dynamic and there may be cases where you have to use nested loops.

Hope [this
guide](https://gist.github.com/chanux/e9ebabb46169b9d2c46c331f56da4800) will
help demistify nested loops!
