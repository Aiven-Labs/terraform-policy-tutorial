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

Our protagonist Rapu will learn as a junior engineer how to decouple and enforce policies using some common tools. When decoupling policies using Open Policy Agent, the structure is pretty consistent no matter the tool or service.

There is a **tool/service**, in this case we will be using Terraform. This tool will generate some data that will be used as **Input** for our decision. The input file will be sent to OPA to be compared against the **Policy**(written in Rego) and any additional **Data**.

As an added bonus Rapu will learn how to write Unit tests for his policies, which is part of clean code and best practicies.

Here's a high-level overview of the system:

![High-level overview](./Terraform_OPA%20Workshop_Overview.png)

Here's a detailed version of the same system:

![Detailed view](Terraform_OPA%20Workshop_Detailed.png)

1. [Setup Terraform files](/01_terraform_deployment_without_OPA.md)
2. [Create the **Input** for our policy](/02_prep_tf_plan_OPA.md)
4. [Write our **Policy** in Rego](/03_write_policy_in_rego.md)
5. [Add **Data** to our policy](/04_create_data_block_rego.md)
6. [Unit testing for our policies](/05_unit_testing_rego.md)

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

| Link  | Description   |
|---|---|
| [Styra Academy](https://academy.styra.com/)  | The styra academy is full of video course to get hands on with Rego and OPA |
| [Rego Playground](https://play.openpolicyagent.org/)  | The Rego playground is available to interactively test your rego policies  |
| [OPA Docs](https://www.openpolicyagent.org/docs/latest/) | The OPA docs are extensively written to answer any questions you may have  |
| [Aiven Docs](https://docs.aiven.io/)  | The Aiven docs will help you get unblocked using any Aiven resources |
| [Terraform Docs](https://developer.hashicorp.com/terraform/docs)  | The Terraform docs are a great reference to get started with Terraform  |

If you have any question, please check out the [FAQ page](FAQ.md) or [raise an issue](https://github.com/dewan-ahmed/terraform-policy-tutorial/issues). 



