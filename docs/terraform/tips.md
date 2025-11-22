# Terraform - Tips

## Using multiple Terraform versions

It's important to be able to use and switch between multiple Terraform versions.
There are situations where you simply cannot update Terraform for certain
projects even though you keep your own projects up to date. Sometimes you need
to switch to the next new version for testing.

In any case, use tools that help manage Terraform versions.

Check out [tenv](https://github.com/tofuutils/tenv), (previously `tfenv`[^1],
previously `TFSwitch`[^2])

If you are already using `mise`, you could probably get away with [just
that](https://mise.jdx.dev/mise-cookbook/terraform.html).

## Terraform logical operator oddities

Do you remember your bafflement when the neat tricks you learned of logical
operators being lazy evaluating didn't work in Terraform?

Consider the following contrived exmaple.

```
variable "person" {
  type = object({
    name    = string
    age     = number
  })
  default = null
}

locals {
  allowed_a = var.person != null && (var.person.age > 21) ? true : false

  allowed_b = var.person != null ? var.person.age > 21 : false
}
```

Before Terraform `1.12.0`, the first expression fails when the value for
`person` variable is not passed. Because Terraform tries to evaluate
`var.person.age` even if person value is null. And the solution was to use the
ternary operator as demonstrated by the second expression.

The change is coming from HCL and it's inherited by OpenTofu at the version
`1.10.0`


[^1]: https://github.com/tfutils/tfenv

[^2]: https://warrensbox.github.io/terraform-switcher/
