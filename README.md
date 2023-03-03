# terraform-policy-tutorial

In this tutorial, you will learn how to use [Open Policy Agent (OPA)](https://www.openpolicyagent.org/docs/latest/) to enforce fine-grained policy control across development and production environments for Terraform deployments. This tutorial assumes that you are already using Terraform.

# The challenge

Rapu started at Crab Inc. as Junior DevOps Engineer. He is shadowing a senior engineer on the team to learn how the team deploys PostgreSQL, Redis, Kafka, and other data-related services across development and production environments. 

The development team is based in Montreal, Canada and they should only create cloud resources on Google Cloud Montreal region. However, to ensure high availability for the company's North American customers, the production environment supports multiple AWS cloud regions in the US East location. 

Your goal is to help Rapu enforce these policies so that resources don't get created in the wrong cloud or region.

## Prerequisites

[Aiven](https://aiven.io/) provides highly-available and scalable data infrastructure based on open-source technologies. For this tutorial, you'll create a [free Aiven account](https://console.aiven.io/signup) and take advantage of [Aiven Terraform Provider](https://registry.terraform.io/providers/aiven/aiven/latest).

Install [OPA](https://www.openpolicyagent.org/docs/latest/#running-opa) and [Terraform](https://developer.hashicorp.com/terraform/downloads).
