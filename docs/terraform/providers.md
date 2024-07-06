# Terraform Provider Mismanagement

## Overview

Terraform changed how provider requirements of a module are handle in Terraform
[version 0.11](https://developer.hashicorp.com/terraform/language/modules/develop/providers#legacy-shared-modules-with-provider-configurations).

In version `<= 0.10`, providers within modules were handled implicitly. In
other words, there was no explicit way to use a different cofiguration of the
same provider, in different modules. The workaround, though not ideal in
practice, was to define providers indside the module itself. (Yours truly still
has flashbacks of being confused as to how this works!)

Fast forward to `0.13`, provider definitions are still allowed in modules, for
backwards compatibility. However, it will take away your ability to use
`for_each`, `count` and `depends_on`.

## Copy Pasta

Fast further forward to the age of.. *checks notes* Terraform version `1.9.x`,
and I still see these ancient practices copy pasted through generations of
code.  Copying over working code and chaging until a semblance of 'working'
appears is a much more wide spread practice than acknowledged.


## Warnings

Terraform however adds warnings about provider mishandling. For better or
worse, no one really cares about warnings! "But wait..", you exclaim. "How
could it be *better*?"." Consider the following scenario.

Like any fine day, I create a module (copy paste code of course) and think how
I'm gonna use it. I was just kidding, taking time to think is for losers, I just
copy paste some code for module call/inilization.

Directory structure
```
.
├── main.tf
└── modules
   └── things-doer
       └── main.tf
```

Main file at the sub-module. In the module, I feel like North Verginia.
```
provider "aws" {
  region = "us-east-1"
}

variable "input" {}

data "aws_region" "current" {}

output "user_input" {
  value = var.input
}

output "aws_region" {
  value  = data.aws_region.current.name
}
```

Main file at the root module. Whoever wrote the code I copy pasted, had
different plans.

```
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ap-southeast-1"
  alias  = "singapore"
}

module "things_doer" {
  source = "./modules/things-doer"
  input  = "hello"

  providers = {
    aws.singapore = aws
  }
}

output "module_output" {
  value = module.things_doer.aws_region
}
```

Now you `terraform init`, just to be greeted with the following warning.


```
│ Warning: Reference to undefined provider
│
│   on main.tf line 10, in module "things_doer":
│   10:     aws.singapore = aws
│
│ There is no explicit declaration for local provider name "aws.singapore" in module.things_doer, so Terraform is assuming you mean to pass a configuration for "hashicorp/aws".
│
│ If you also control the child module, add a required_providers entry named "aws.singapore" with the source address "hashicorp/aws".
╵
```

As someone who copy pastes things but still tries to get rid of the
warnings, I might just go and do what Terraform tells me to do and add
`required_providers` config that's totally irrelevant to what I might have been
doing.  However it's easier to just ignore the warning and let the unfortunate
who get to work on this code base in the future confused/annoyed.

This scenario is not that difficult to digest because it's just a few lines of
code and the provider naming is still sane. Now imagine a case where the code
base is quite big and provider naming is out of whack! Things get pretty hard
to reason about.

## Take home

- Be aware of the Terraform version you are using and try to keep up with the
  newer versions.
- Do not define/initialize providers in modules (sub-module) if you are using
  Terraform `>= 0.11` or unless you really know what you are doing.
- `>= 0.11` : If your module needs providers of different configuration, use
  [required_providers](https://developer.hashicorp.com/terraform/language/modules/develop/providers#provider-version-constraints-in-modules)
  directive to define it in the module (and pass down the necessary providers
  from root module).
- If you really have to worry a lot about providers of different configuration,
  double check your design.
- Take time to read the documentaion.
    - [Provider Configuration](https://developer.hashicorp.com/terraform/language/providers/configuration)
    - [Providers within modules](https://developer.hashicorp.com/terraform/language/modules/develop/providers)

To wrap up, if I did my bad example above correctly, it would look like the
following.

Main of the root module
```
provider "aws" {
  region = "us-east-1"
}

module "things_doer" {
  source = "./modules/things-doer"
  input  = "hello"
}

output "module_output" {
  value = module.things_doer.aws_region
}
```

Main of the sub-module
```
variable "input" {}

data "aws_region" "current" {}

output "user_input" {
  value = var.input
}

output "aws_region" {
  value  = data.aws_region.current.name
}
```
