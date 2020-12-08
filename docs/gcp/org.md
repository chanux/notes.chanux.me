# GCP: Organization

## Getting Started

When working with GCP, it's important to understand how organization structure
affects your work.

Tasks like setting up VPC network sharing
[require](https://cloud.google.com/vpc/docs/provisioning-shared-vpc#permissions)
higher level access.

The easiest way to get this is with [cloud
identity](https://support.google.com/a/answer/7389973?hl=en) free edition.
Before getting started, make sure you have following.

- You need to own a domain.
- Have email configured for your domain.
    - [Forward Email](https://forwardemail.net/en) has a free tier
- Be ready to verify your domain ownership with a TXT record in DNS.
- A credit card.

Once you sign up, you will need to create project as cloud identity admin user
to have your organization resource provisioned (This is automatic).

Give yourself (admin account) "Organization Admin" role from IAM Section.

## Terraform Automation

It's possible to do Folders/Projects creation, API enabling with Infrastruture
as Code. Google Cloud Foundation Toolkit provides a good set of Terraform
modules for this.

The [Project Factory](https://github.com/terraform-google-modules/terraform-google-project-factory)
module is a quite a good way to create the projects.

The ideal way is to cretae a "Seed Project" and a Service Account in to get the
key to be used by Terraform. The Project Factory module provides a [helper
scrpit](https://github.com/terraform-google-modules/terraform-google-project-factory#script-helper)
to create the Service Account and assign it all the permission as required
by the module.

Also, create a GCS bucket in the Seed Project for storing Terraform State for
org management code.

## Some common tasks

** Get Organization ID **

```
gcloud organizations list
```

** Create Folder **

```
gcloud alpha resource-manager folders create --display-name=Prod --organization=890794238538
```

** List Folder **

```
gcloud beta resource-manager folders list --organization=<ORG_ID>
```

## Shared VPC Setup

** Give Service Account Access needed for configuring VPC Sharing **

```
gcloud resource-manager folders add-iam-policy-binding <FOLDER_ID> --member='serviceAccount:terraform-automation@project-foo-1337.iam.gserviceaccount.com' --role="roles/compute.networkAdmin"
```

```
gcloud beta resource-manager folders add-iam-policy-binding <FOLDER_ID> --member='serviceAccount:terraform-automation@project-foo-1337.iam.gserviceaccount.com' --role="roles/compute.xpnAdmin"
```

** More on Shared VPC **

https://cloud.google.com/iam/docs/job-functions/networking
https://cloud.google.com/vpc/docs/provisioning-shared-vpc#nominating_shared_vpc_admins_for_the_organization
