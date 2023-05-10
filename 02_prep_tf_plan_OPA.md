# Section two

Then initialize Terraform and ask it to calculate what changes it will make and store the output in `plan.binary`.

```shell
terraform init
terraform plan --out tfplan.binary
```

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