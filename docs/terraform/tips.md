# Terraform - Tips

## Using multiple Terraform versions

It's important to be able to use and switch between multiple Terraform version.
There are situations where you simply cannot update Terraform for certain
projects even though you keep your own projects up to date. Sometimes you need
to switch to the next new version for testing.

In any case, use tool that help manage Terraform versions.

Check out [tenv](https://github.com/tofuutils/tenv), a successor to `tfenv` [1]
which I used to use.


**Old note**

With Terraform 0.11 to 0.12 changes, it's especially important to be able to
easily switch between different Terraform versions.  TFSwitch [2] allows easily
managing and switching between different Terraform versions.

[1] https://github.com/tfutils/tfenv

[2] https://warrensbox.github.io/terraform-switcher/
