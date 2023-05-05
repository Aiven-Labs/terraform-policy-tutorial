# terraform-policy-tutorial

In this tutorial, you will learn how to use [Open Policy Agent (OPA)](https://www.openpolicyagent.org/docs/latest/) to enforce fine-grained policy control across development and production environments for Terraform deployments. This tutorial assumes that you are already using Terraform.

# The challenge

Rapu started at Crab Inc. as Junior DevOps Engineer. He is shadowing a senior engineer on the team to learn how the team deploys PostgreSQL, Redis, Kafka, and other data-related services across development and production environments. 

The development team is based in Montreal, Canada and they should only create cloud resources on Google Cloud Montreal region. However, to ensure high availability for the company's North American customers, the production environment supports multiple AWS cloud regions in the US East location. Previously, there was no guardrails in place and Rapu deployed to cloud regions where he wasn't supposed to deploy. 

Your goal is to help Rapu enforce these policies so that resources don't get created in the wrong cloud or region.

## Prerequisites

The concept of the tutorial is agnostic of what Terraform provider you choose. For the sake of a demo, I'll choose [Aiven Terraform Provider](https://registry.terraform.io/providers/aiven/aiven/latest). [Aiven](https://aiven.io/) provides highly-available and scalable data infrastructure based on open-source technologies. For this tutorial, you'll create a [free Aiven account](https://console.aiven.io/signup) and [an Aiven authentication token](https://docs.aiven.io/docs/platform/howto/create_authentication_token).

Install [OPA](https://www.openpolicyagent.org/docs/latest/#running-opa) and [Terraform](https://developer.hashicorp.com/terraform/downloads).

## Step 1: Write the Terraform files

In this section, you'll help Rapu create Terraform files that contains an Aiven for Redis resource. This can be any cloud resource for your use case and Aiven for Redis is used as an example. Besides the Aiven for Redis resource in the `services.tf` file, create a `provider.tf` file for the provider and version details. You'll also create a `variables.tf` to define the required variables for Aiven Terraform Provider.

In an empty directory, create these three files:

`provider.tf` file:

```terraform
terraform {
  required_providers {
    aiven = {
      source  = "aiven/aiven"
      version = "~> 4.1.0"
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
resource "aiven_redis" "redis-demo" {
    project = "devrel-dewan" # Find your Aiven project name from top-left of Aiven console
    plan = "hobbyist" # For this exercise, the hobbyist plan will do
    service_name = "redis-demo" # Choose any service name
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

For improved readability you can pipe the output through jq before saving the file.

```shell
terraform show -json tfplan.binary | jq > tfplan.json
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
                    "address": "aiven_redis.redis-demo",
                    "mode": "managed",
                    "type": "aiven_redis",
                    "name": "redis-demo",
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
                        "service_name": "redis-demo",
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
            "address": "aiven_redis.redis-demo",
            "mode": "managed",
            "type": "aiven_redis",
            "name": "redis-demo",
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
                    "service_name": "redis-demo",
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
                "version_constraint": "~> 4.1.0",
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
                    "address": "aiven_redis.redis-demo",
                    "mode": "managed",
                    "type": "aiven_redis",
                    "name": "redis-demo",
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
                            "constant_value": "redis-demo"
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

> **Note** The api token in the above example is invalid and is shown as an example only.

## Step 4: Write the OPA policy to check the plan

OPA policies are written in [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/). The following Rego checks if Rapu can deploy to a development environment or a production environment based on the type of Terraform resource and the cloud region they choose. 

In the same folder, create a sub-folder called **policy** and create a file within called **terraform.rego**. Add the following code to that file:

```
package terraform.analysis

import input as tfplan
import future.keywords

dev_env_cloud_prefix := "google-northamerica-northeast1"

prod_env_cloud_prefix := "aws-us-east"

resource_types := {"aiven_kafka", "aiven_pg", "aiven_opensearch", "aiven_redis"}

default allow_dev_deployment := false

default allow_prod_deployment := false

allow_dev_deployment if {
	some resource in tfplan.planned_values.root_module.resources
	resource.type in resource_types
	resource.values.cloud_name == dev_env_cloud_prefix
}

allow_prod_deployment if {
	some resource in tfplan.planned_values.root_module.resources
	resource.type in resource_types
	startswith(resource.values.cloud_name, prod_env_cloud_prefix)
}
```

Let's analyze this file. Crab Inc. uses PostgreSQL for their relational database, Redis for caching, OpenSearch for search and analytics, and Kafka as the central message bus. Therefore, `resource_types` field limits the use of these four resources only. Crab Inc. allows developers to deploy only in the Montreal, Canada region and `dev_env_cloud_prefix` field takes care of that requirement. Similarly, production deployments are allowed at any one of Aiven's supported AWS cloud regions in the USA East coast which `prod_env_cloud_prefix` field takes care of.

Execute the following command from the main directory to find out if OPA would allow the Terraform deployment to go through:

```
./opa exec --decision terraform/analysis/allow_prod_deployment --bundle policy/ tfplan.json
```

With the current Terraform service definition, the output of the above command will be:

```shell
{
  "result": [
    {
      "path": "tfplan.json",
      "result": true
    }
  ]
}
```

If you have [jq](https://stedolan.github.io/jq) installed on your machine, you can find the exact result with:

```
./opa exec --decision terraform/analysis/allow_prod_deployment --bundle policy/ tfplan.json | jq '.result[0].result'
```

The `opa exac` command is taking in the `tfplan.json` as an input and validating this against the policy we defined in the **allow_prod_deployment** section under policy/terraform.rego file. **terraform/analysis** is denoting the package name in that Rego. 

Let's make a change in the `services.tf` file and change the `cloud_name` field to `google-northamerica-northeast1`. Now if you repeat steps 2, 3, and 4, the output from the `opa exec` command should be `false`.

hint:

```bash
terraform plan --out tfplan.binary
terraform show -json tfplan.binary | jq > tfplan.json
opa exec --decision terraform/analysis/allow_prod_deployment --bundle ./policy tfplan.json
```

## Step 5 using the data block

Rapu has done a great job implimenting his first policy. However, typically data won't be hard coded in the policy. So let's rewrite the current policy and create some news ones.

Create the following data.json file in the `policy` folder this should be right next to our rego file: 

```json
{
  "team": "devrel",
  "app": "crab_cage",
  "dev": {
    "cloud": "google-northamerica-northeast1"
  },
  "prod": {
    "cloud": "aws-us-east"
  }
}
```

Now that we have a data file, we can go back and update our Rego policy.

terraform.rego

```rego
package terraform.analysis

import input as tfplan
import future.keywords

# notice we removed the hard coded variables

resource_types := {"aiven_kafka", "aiven_pg", "aiven_opensearch", "aiven_redis"}

default allow_dev_deployment := false

default allow_prod_deployment := false

allow_dev_deployment if {
	some resource in tfplan.planned_values.root_module.resources
	resource.type in resource_types
	resource.values.cloud_name == data.dev.cloud # referencing the new data block
}

allow_prod_deployment if {
	some resource in tfplan.planned_values.root_module.resources
	resource.type in resource_types
	startswith(resource.values.cloud_name, data.prod.cloud)  # referencing the new data block
}
```

Now we can rerun the policy check. Remember we added the data file to our policy folder so OPA should be aware of the new data.

```bash
terraform plan --out tfplan.binary
terraform show -json tfplan.binary | jq > tfplan.json
opa exec --decision terraform/analysis/allow_prod_deployment --bundle ./policy tfplan.json
```


## Challenge: Add some rules on your own

Now that you have 1 policy in place, cany you expand this policy to include a few more rules? You can try the following or make up a rule of your own.

1. project must start with team name
2. service_name must include app name

## Step 6: Testing the OPA policy

Now that we have a few policies in place, we are going to add unit tests to ensure our policies are good before we enforce them in production.

Create a rego file for our tests. 

test_terraform.rego

```rego
package terraform.test_analysis

import terraform.analysis

test_allow_dev_deployment if {

allow_dev_deployment with input as { "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aiven_redis.redis-demo",
          "mode": "managed",
          "type": "aiven_redis",
          "name": "redis-demo",
          "provider_name": "registry.terraform.io/aiven/aiven",
          "schema_version": 1,
          "values": {
            "cloud_name": "aws-us-east",
            "plan": "hobbyist",
            "project": "devrel-dewan",
            "service_name": "redis-demo",
            "service_type": "redis",
          }
        }
      ]
    }
  }
}

}

test_not_allow_prod_deployment if {

not allow_prod_deployment with input as { "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aiven_redis.redis-demo",
          "mode": "managed",
          "type": "aiven_redis",
          "name": "redis-demo",
          "provider_name": "registry.terraform.io/aiven/aiven",
          "schema_version": 1,
          "values": {
            "cloud_name": "aws-us-east",
            "plan": "hobbyist",
            "project": "devrel-dewan",
            "service_name": "redis-demo",
            "service_type": "redis",
          }
        }
      ]
    }
  }
}

}

Bonus points for writing this with the DRY (Don't Repeat Yourself) coding practices.

```

## Challenge add unit tests for the additional policy rules you created

test_project_name {
    # insert code here
}

test_service_name {
    # insert code here
}


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
[OPA Docs](https://www.openpolicyagent.org/docs/latest/)
[Terraform Docs](https://developer.hashicorp.com/terraform/docs)
[Aiven docs](https://docs.aiven.io/)


