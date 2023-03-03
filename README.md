# terraform-policy-tutorial

In this tutorial, you will learn how to use [Open Policy Agent (OPA)](https://www.openpolicyagent.org/docs/latest/) to enforce fine-grained policy control across development and production environments for Terraform deployments. This tutorial assumes that you are already using Terraform.

# The challenge

Rapu started at Crab Inc. as Junior DevOps Engineer. He is shadowing a senior engineer on the team to learn how the team deploys PostgreSQL, Redis, Kafka, and other data-related services across development and production environments. 

The development team is based in Montreal, Canada and they should only create cloud resources on Google Cloud Montreal region. However, to ensure high availability for the company's North American customers, the production environment supports multiple AWS cloud regions in the US East location. 

Your goal is to help Rapu enforce these policies so that resources don't get created in the wrong cloud or region.

## Prerequisites

[Aiven](https://aiven.io/) provides highly-available and scalable data infrastructure based on open-source technologies. For this tutorial, you'll create a [free Aiven account](https://console.aiven.io/signup) and take advantage of [Aiven Terraform Provider](https://registry.terraform.io/providers/aiven/aiven/latest).

Install [OPA](https://www.openpolicyagent.org/docs/latest/#running-opa) and [Terraform](https://developer.hashicorp.com/terraform/downloads).

## Step 1: Write the Terraform files

In this section, you'll create a Terraform file that contains an Aiven for Redis resource. This can be any cloud resource for your use case and Aiven for Redis is used as an example. Besides the Aiven for Redis resource in the `services.tf` file, you'll create a `provider.tf` file for the provider and version details. You'll also create a `variables.tf` to define the required variables for Aiven Terraform Provider.

In an empty directory, create these three files:

`provider.tf` file:

```terraform
terraform {
  required_providers {
    aiven = {
      source  = "aiven/aiven"
      version = "~> 4.0.0"
    }
  }
}

provider "aiven" {
  api_token = var.aiven_api_token
}
```

`variables.tf` file:

```terraform
variable "aiven_api_token" {
  description = "Aiven console API token"
  type        = string
}

variable "project_name" {
  description = "Aiven console project name"
  type        = string
}
```

`service.tf` file:

```terraform
resource "aiven_redis" "dewan-redis-terraform" {
project = "devrel-dewan" # Find your Aiven project name from top-left of Aiven console
plan = "hobbyist" # For this exercise, the hobbyist plan will do
service_name = "dewan-redis-demo" # Choose any service name
cloud_name = "google-northamerica-northeast1" # Choose any cloud region from https://docs.aiven.io/docs/platform/reference/list_of_clouds
}
```

## Step 2: Create and save a Terraform plan

Then initialize Terraform and ask it to calculate what changes it will make and store the output in `plan.binary`.

```shell
terraform init
terraform plan --out tfplan.binary
```

## Step 3: Convert the Terraform plan into JSON

Use the command terraform show to convert the Terraform plan into JSON so that OPA can read the plan.

```shell
terraform show -json tfplan.binary > tfplan.json
```

Here is a sample output of `tfplan.json`:

```json

{
    "format_version": "1.1",
    "terraform_version": "1.2.8",
    "variables": {
        "aiven_api_token": {
            "value": "3Xi1J+E0G3vo0fwr2vWMLl0XgHwRyA6pCX8C6rQQZVhoyFfz9WAMreaGZPAI+jRUGWgtslQKQtIZTICCDZlZkQn3sRYHGBcAxgXqoiT3l9cYVbVvyPNSVPGHrSvBhSCXIYgWX3AXkOG/kQiJ1r0CZn0Y0gK/pRyiti6dImIzyEsZWja9FZk+mV/M/6BAZMKpa/EokkKUj4puMpUX4B3//slU9yUdicr2wCe/uyx53K64rU/OWZYCbqfTI6QcsjZc1wd8/a+0aLsv651qZwxmgTAenmj0JC5tXWD+Dx89NaiZcUdGxhyg58ZYfYh6U3YDm5S/ovDcvq9m/ffMKbb2Sut2vVELPO1l6AA70U1besBR0dE="
        },
        "project_name": {
            "value": "devrel-dewan"
        }
    },
    "planned_values": {
        "root_module": {
            "resources": [
                {
                    "address": "aiven_redis.dewan-redis-terraform",
                    "mode": "managed",
                    "type": "aiven_redis",
                    "name": "dewan-redis-terraform",
                    "provider_name": "registry.terraform.io/aiven/aiven",
                    "schema_version": 0,
                    "values": {
                        "additional_disk_space": null,
                        "cloud_name": "aws-us-east1",
                        "disk_space": null,
                        "maintenance_window_dow": null,
                        "maintenance_window_time": null,
                        "plan": "hobbyist",
                        "project": "devrel-dewan",
                        "project_vpc_id": null,
                        "redis_user_config": [],
                        "service_integrations": [],
                        "service_name": "dewan-redis-demo",
                        "service_type": "redis",
                        "static_ips": null,
                        "tag": [],
                        "termination_protection": null,
                        "timeouts": null
                    },
                    "sensitive_values": {
                        "components": [],
                        "redis": [],
                        "redis_user_config": [],
                        "service_integrations": [],
                        "tag": []
                    }
                }
            ]
        }
    },
    "resource_changes": [
        {
            "address": "aiven_redis.dewan-redis-terraform",
            "mode": "managed",
            "type": "aiven_redis",
            "name": "dewan-redis-terraform",
            "provider_name": "registry.terraform.io/aiven/aiven",
            "change": {
                "actions": [
                    "create"
                ],
                "before": null,
                "after": {
                    "additional_disk_space": null,
                    "cloud_name": "aws-us-east1",
                    "disk_space": null,
                    "maintenance_window_dow": null,
                    "maintenance_window_time": null,
                    "plan": "hobbyist",
                    "project": "devrel-dewan",
                    "project_vpc_id": null,
                    "redis_user_config": [],
                    "service_integrations": [],
                    "service_name": "dewan-redis-demo",
                    "service_type": "redis",
                    "static_ips": null,
                    "tag": [],
                    "termination_protection": null,
                    "timeouts": null
                },
                "after_unknown": {
                    "components": true,
                    "disk_space_cap": true,
                    "disk_space_default": true,
                    "disk_space_step": true,
                    "disk_space_used": true,
                    "id": true,
                    "redis": true,
                    "redis_user_config": [],
                    "service_host": true,
                    "service_integrations": [],
                    "service_password": true,
                    "service_port": true,
                    "service_uri": true,
                    "service_username": true,
                    "state": true,
                    "tag": []
                },
                "before_sensitive": false,
                "after_sensitive": {
                    "components": [],
                    "redis": [],
                    "redis_user_config": [],
                    "service_integrations": [],
                    "service_password": true,
                    "service_uri": true,
                    "tag": []
                }
            }
        }
    ],
    "configuration": {
        "provider_config": {
            "aiven": {
                "name": "aiven",
                "full_name": "registry.terraform.io/aiven/aiven",
                "version_constraint": "~> 4.0.0",
                "expressions": {
                    "api_token": {
                        "references": [
                            "var.aiven_api_token"
                        ]
                    }
                }
            }
        },
        "root_module": {
            "resources": [
                {
                    "address": "aiven_redis.dewan-redis-terraform",
                    "mode": "managed",
                    "type": "aiven_redis",
                    "name": "dewan-redis-terraform",
                    "provider_config_key": "aiven",
                    "expressions": {
                        "cloud_name": {
                            "constant_value": "aws-us-east1"
                        },
                        "plan": {
                            "constant_value": "hobbyist"
                        },
                        "project": {
                            "constant_value": "devrel-dewan"
                        },
                        "service_name": {
                            "constant_value": "dewan-redis-demo"
                        }
                    },
                    "schema_version": 0
                }
            ],
            "variables": {
                "aiven_api_token": {
                    "description": "Aiven console API token"
                },
                "project_name": {
                    "description": "Aiven console project name"
                }
            }
        }
    }
}
```

> :note: The api token in the above example is invalid and is shown as an example only.