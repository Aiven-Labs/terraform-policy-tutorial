# terraform-policy-tutorial

In this tutorial, you will learn how to use [Open Policy Agent (OPA)](https://www.openpolicyagent.org/docs/latest/) to enforce fine-grained policy control across development and production environments for Terraform deployments. This tutorial assumes that you are already using Terraform.

# The challenge

Rapu started at Crab Inc. as Junior DevOps Engineer. He is shadowing a senior engineer on the team to learn how the team deploys PostgreSQL, Redis, Kafka, and other data-related services across development and production environments. 

The development team is based in Montreal, Canada and they should only create cloud resources on Google Cloud Montreal region. However, to ensure high availability for the company's North American customers, the production environment supports multiple AWS cloud regions in the US East location. Previously, there was no guardrails in place and Rapu deployed to cloud regions where he wasn't supposed to deploy. 

Your goal is to help Rapu enforce these policies so that resources don't get created in the wrong cloud or region.

## Prerequisites

The concept of the tutorial is agnostic of what Terraform provider you choose. For the sake of a demo, I'll choose [Aiven Terraform Provider](https://registry.terraform.io/providers/aiven/aiven/latest). [Aiven](https://aiven.io/) provides highly-available and scalable data infrastructure based on open-source technologies. For this tutorial, you'll create a [free Aiven account](https://console.aiven.io/signup) and [an Aiven authentication token](https://docs.aiven.io/docs/platform/howto/create_authentication_token).

Install [OPA](https://www.openpolicyagent.org/docs/latest/#running-opa) and [Terraform](https://developer.hashicorp.com/terraform/downloads).

## The Story

In this section, you'll help Rapu create Terraform files that contains an Aiven for Redis resource. This can be any cloud resource for your use case and Aiven for Redis is used as an example. Besides the Aiven for Redis resource in the `services.tf` file, create a `provider.tf` file for the provider and version details. You'll also create a `variables.tf` to define the required variables for Aiven Terraform Provider.

1. [Write the Terraform files](/section_1.md)
2. [Create and save a Terraform plan](/section_2.md)
3. [Convert the Terraform plan into JSON](/section_3.md)
4. [Write the OPA policy to check the plan](/section_4.md)
5. [using the data block](/section_5.md)
6. [Testing the OPA policy](/section_6.md)

## Wrap up and conclusion

Let's look at all the things Rapu has accomplished on his first project at Crab, Inc.

- Created Aiven terraform file
- Convert terraform plan into binary 
- Convert binary output into json 
- Created a Rego policy to verify the resource configuration
- Tested our Rego policy on our local CLI
- Cleaned up our Rego policy by moving hard coded data to a data file
- Wrote addition policies to very more specifics of the resources
- Added unit tests for each of our policies

This is the of end of our workshop, thanks for spending the time learning with us today. Here are some additional resources to help you learn about the tools in this workshop. 

[Learn Rego](https://academy.styra.com/)
[Test Rego](https://play.openpolicyagent.org/)
[OPA Docs](https://www.openpolicyagent.org/docs/latest/)
[Terraform Docs](https://developer.hashicorp.com/terraform/docs)
[Aiven docs](https://docs.aiven.io/)


