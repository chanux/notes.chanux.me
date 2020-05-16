# Workflow

## Intro

The idea of this doc is to put together a modern workflow for infrastructure
management. I don't in anyway claim originality. This is just an attempt to 
collect ideas from around the web, books etc.

A non exhaustive list of goals would be

- Follow **Infrastructure as Code** concepts
- Test the infrastructure
- Build up resources which facilitates repeatability

**Complete automation** is probably a non-realistic goal that would distract us
rather than helping us move in light speed. James Nugent of Joyent puts it
[like this](https://youtu.be/8ZRa0lLq8OU?t=511)

!!! Quote
    What we are not gonna do is aim for a single `terraform apply` to create
    everything. Cause it's great for demos but it's **not that realistic in the
    real world**.

Complete automation is [a great dream](http://autopilotpattern.io) to have
though.

## Summary

Let's try to build up a workflow for..

- Setting up roles, permissions etc.
- Provisioning infra resources
    - Networks, DNS, VMs etc.
- Installing software
    - can be done with either shell scripts
    - or a config management system like Ansible
- Configuring software
- Starting up
    - joining a cluster etc.
- Verifying everything is in order (Testing)

### Managing Infrastructure

**Infrastructure as code**

!!! Quote
    Infrastructure as code (IaC) is the process of managing and provisioning
    computer data centers through machine-readable definition files, rather
    than physical hardware configuration or interactive configuration tools

There are many tools that facilitates defining your infrastructure as code. AWS
Cloudformation and GCP Deployment Manager are two vendor specific examples. But
there's another player who supports multiple cloud environments. That is
Terraform by Hashicorp and that's what we will focus on.

Terraform is a powerful infrastructure automation tool. You can
describe your infrastruture in a simple configuration language and have it
automatically created for you.

You can mange this configuration using a source control system like git. This
gives you great control over your infrastructure. This also facilitates team
collaboration on infrastructure. Terraform [remote
state](https://www.terraform.io/docs/state/remote.html) makes things even
better in a team environment.

On Google Cloud Platform (GCP), Terraform can manage resources starting from
`folders`. It can manage `projects`, `roles`, `policies` etc. as well. Anyhow
to do this, Terrafrom requires *adequate power*. Whether to do these with
Terraform and how to manage the risks involved should be carefully thought out.

It's best to have Terraform execute in an [automated
environment](https://learn.hashicorp.com/terraform/development/running-terraform-in-automation).
This environment can be tightly controlled (ex: limited access to the
environment, well defined and controlled peocess for execution) for security
and safety.  This way, the *adequate power* I mentioned before can be well
contianed.

The developer Terraform setups only get read-only access to the infrastructure,
so they can do their task without hindrance and anxiety of causing unnecessary
trouble.


### Install Software and configure

One idea is to build VM images with [Packer](https://www.packer.io/) baking in
as much as possible (Install software, add configuration) instead of
installing/configuring upon provisioning. Anyhow, there will still be the need
for startup scripts for tasks that can only be done once system is up. Adding
the instace IP to a config file or having the instance join a cluster are
couple examples. 

This idea especially saves time in cases where there are lots of new
deployments happening.

Immutable infrastructure with Packer, Ansible and terraform: [article](https://itnext.io/immutable-infrastructure-using-packer-ansible-and-terraform-7ca6f79582b8)

The other way is to do a Vanilla provision and have stuff installed/configured
with a configuration management system like Puppet or Ansible.

### Managing multiple environments

Let's take an example case of multiple environments. Imagine that we have dev,
QA/staging and production environments.  The ideal is to keep these
environments identical. If we are to follow this, we can do it with Terraform
without duplicating code.

For this just have the terraform in one code repository and manage different
configurations (`.tfvars` files) inside directories. This
[write-up](https://medium.com/@uri.tau/terraform-layout-be3674dfe657) explains
this idea very well.

Anyhow, nothing is perfect. Especially if the technical ideals clash with
finances. When this happens, the technical ideals go out of the window real
quick.

For example you may have to give up on having identical dev, staging and prod
environment.  In this case we have to copy the code between different code
repos created per each environment. This can be messy and error prone. **But**
when there are changes in infra between environments, managing it in one code
repo is also gonna be messy and complicated.

When infra between environments change, the tradeoffs of copying code base seem
to win at least with my current experience in Terraform. Usually when the
infrastructure are different they are likely to get further diverged.

**Terraform Workspaces**

Terraform [Workspaces](https://www.terraform.io/docs/state/workspaces.html) can
be utilized for deploying multiple environments with the same code base.
Workspaces will manage the state for each `workspace <=> environment`
separately with supported backends.

### Testing

- Self testing infrastructure as code: [article](https://opencredo.com/blogs/self-testing-infrastructure-as-code/)

- Infrastructure tests with Go: [Gruntworks Terratest](https://github.com/gruntwork-io/terratest)

- Unit tests and integration [tests](https://www.contino.io/insights/top-3-terraform-testing-strategies-for-ultra-reliable-infrastructure-as-code) for Terraform

- [Test driven inftastructure](https://medium.com/@Joachim8675309/test-driven-infrastructure-on-gcp-18214ed05571) on GCP with Terraform

## Misc

- Try to support one or minimum number of Operating Systems.
    - This helps reducing cognitive load required in operations.
    - Makes it easier to debug
- Always think through and agree upon naming conventions.
    - Saves confusion
    - Document these to have everyone on the same page

## Notes

System Policy can be put in code thanks to [Open Policy Agent](https://www.openpolicyagent.org/)
