# Terraform: The Basics

## Install

Let's start with something overly obvious: To run Terraform, you need it to be
installed on your system.

(Check for the latest version [here](https://releases.hashicorp.com/terraform/))

Set the Terraform version
```
export TF_VER=1.6.9
```

Download

=== "curl"

    ```
    curl https://releases.hashicorp.com/terraform/${TF_VER?}/terraform_${TF_VER?}_linux_amd64.zip | funzip > /usr/local/bin
    ```
=== "wget"

    ```
    wget https://releases.hashicorp.com/terraform/${TF_VER?}/terraform_${TF_VER?}_linux_amd64.zip -O - | funzip > /usr/local/bin
    ```
=== "brew"

    ```
    brew install terraform
    ```

## Prepare

We will focus on using Terraform in Google Cloud Platform (GCP). Terraform
needs a *Service Account* to communicate with GCP.


Create a Servie account with adequate permissions `IAM > Service accounts` and
create a JSON credentials file for it.

`cat provider.tf`
```
provider "google" {
 credentials = file("/path/to/service-account-key.json")
 project     = "your-project-id"
 region      = "us-central-1"
}
```

Now you can use your credentials file in Terraffrom provider definition along
with project id and region name. You could set that in your CLI environment
instead of setting credentials field in provider section as well.

```
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
```

Initialize terraform

```
terraform init
```

This will download provider plugin, modules (if any) etc.

We are now ready to Terraform GCP!

## Terraform GCP

Our first instance.

Add below content in `main.tf` file.

`cat main.tf`
```hcl
// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "first-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "us-central1-a"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}
```

Run

```
terraform plan
```

Umm.. Did something go wrong?

The problem is, we are using `random_id` resource there (It's a good practice
to randomize resource names). This needs random plugin which Terraform needs to
pull down. So run `terraform init` once again.

Now, `terraform plan` will show you a summary of what to be done. Which
resources to be created, which to be deleted and which to be simply changed. In
our case, it's just creating the random id and the actual vm instance, because
ours is a fresh start.

We use `terraform apply` to apply a **plan** and have the resources
created/deleted/changed.

```
terraform plan -out my-plan.out
```

```
terraform apply my-plan.out
```

This will create an instance on GCP for us. The rest is pretty much the same
except you have to spend time on terraform docs (and stack overflow and github
issues, on blogs, in github reading code and on and on but I digress)

Happy terraforming!

## Parameterize

It's an amazing feeling when you can describe something in code
(**Configuration!** Let's be real) and have it done for you automatically. But
there's more to it.  You can parameterize and reuse what you just wrote.

For example, if you want to have an instance of different type and in
a different zone, do we just copy paste and edit the fields?

Well.. instead of that, we can use this ground breaking concept called..

..**variables**!

`cat variables.tf`

```
variable "gcp_machine_type" {
  description = "GCP compute instance type.
}

variable "gcp_region_zone" {
  description = "The GCP zone to deploy instance"
}
```

Now to use these variables, update your `main.tf` as follows.

```
 machine_type = var.gcp_machine_type
 zone         = var.gcp_region_zone
```

Now we run `terraform plan` and `terraform apply` and be done with it. Not so
fast! Terraform doesn't know what to use for `gcp_project_id` and `gcp_region`.
Try running `terraform plan`. It'll ask us what to use for the varibales.

This is not gonna be fun when we have more variabales and/or when we run it
dozens of times. There are two things to do.

1. Set a default to varibale.
2. Provide a `.tfvars` file with the vaules.

See below for an example of setting a default.

```hcl
variable "gcp_region_zone" {
  description = "The GCP region to deploy resources"
  default     = "asia-southeast1-a"
}
```

That's easy.

Now let's look at `.tfvars`

`cat settings.tfvars`
```
gcp_machine_type = "e2-micro"
gcp_region_zone  = "asia-southeast1-a"
```

To incoporate our shiny new `settings.tfvars` file in Terraform, run *plan* as
follows.

```
terraform plan -out=my-plan.out -var-file=settings.tfvars
```

!!! Tip
    If you name your `.tfvars` file `settings.auto.tfvars`, terraform will
    automatically pick it up. (It doesn't have to be named **settings**. It
    could be `what-i-fancy.auto.tfvars` and nobody cares.)

We are almost all ready to Terraform everything. Before we wrap up, there's
something very importnant to cover. That is Terraform Modules.

## Modules

Terraform modules allows code reuse of insane scale. For example, if you want
to deploy a Consul backed Vault cluster, There's
a [module](https://github.com/hashicorp/terraform-google-vault) for it. You can
find more modules at Terraform module
[registry](https://registry.terraform.io/).

Using readymade modules is not the only appeal in Terraform modules. We can
make our own modules to make our lives easier. This [Hashiconf '17
talk](https://www.youtube.com/watch?v=LVgP63BkhKQ) by Gruntwork co-founder is
a great starting point.

## Fin

If you read this far, you deserve a little bit more. Please find the code we
did here, but with little twists, on
[github](https://github.com/chanux/terraform-the-basics)

Also, if you are up for a true adventure, do not miss the
[exercise](exercise.md)!

That's all folks!
