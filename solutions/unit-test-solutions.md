### Solutions to the unit test exercise

Here's the `terraform.rego` and `test_terraform.rego` files to test the following requirements:

- policy to test that Aiven project name must contain team name (from `data.json`)

- policy to test to check that Aiven service name must contain app name (from `data.json`)

`terraform.rego`:

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
	startswith(resource.values.cloud_name, data.dev.cloud)  # referencing the new data block
}

allow_prod_deployment if {
	some resource in tfplan.planned_values.root_module.resources
	resource.type in resource_types
	startswith(resource.values.cloud_name, data.prod.cloud)  # referencing the new data block
}
allow_project_name {
	some resource in tfplan.planned_values.root_module.resources
    resource.type in resource_types
    contains(resource.values.project, data.team)
}

allow_service_name {
    some resource in tfplan.planned_values.root_module.resources
    resource.type in resource_types
	contains(resource.values.service_name, data.app)
}
```

`test_terraform.rego`:

```rego

package terraform.test_analysis

import data.terraform.analysis

test_allow_dev_deployment {
	analysis.allow_dev_deployment with input as {"planned_values": {"root_module": {"resources": [{
		"address": "aiven_redis.redis-demo",
		"mode": "managed",
		"type": "aiven_redis",
		"name": "redis-demo",
		"provider_name": "registry.terraform.io/aiven/aiven",
		"schema_version": 1,
		"values": {
			"cloud_name": "google-northamerica-northeast1",
			"plan": "hobbyist",
			"project": "devrel-dewan",
			"service_name": "redis-demo",
			"service_type": "redis",
		},
	}]}}}
}

test_not_allow_prod_deployment {
	not analysis.allow_prod_deployment with input as {"planned_values": {"root_module": {"resources": [{
		"address": "aiven_redis.redis-demo",
		"mode": "managed",
		"type": "aiven_redis",
		"name": "redis-demo",
		"provider_name": "registry.terraform.io/aiven/aiven",
		"schema_version": 1,
		"values": {
			"cloud_name": "google-northamerica-northeast1",
			"plan": "hobbyist",
			"project": "devrel-dewan",
			"service_name": "redis-demo",
			"service_type": "redis",
		},
	}]}}}
}

test_allow_project_name {
    analysis.allow_project_name with input as {"planned_values": {"root_module": {"resources": [{
        "address": "aiven_redis.dewan-redis-terraform",
        "mode": "managed",
        "type": "aiven_redis",
        "name": "dewan-redis-terraform",
        "provider_name": "registry.terraform.io/aiven/aiven",
        "schema_version": 1,
        "values": {
            "cloud_name": "google-northamerica-northeast1",
            "plan": "hobbyist",
            "project": "devrel-dewan",
            "service_name": "dewan-redis-terraform",
            "service_type": "redis",
        },
    }]}}}
}

test_allow_service_name {
    analysis.allow_service_name with input as {"planned_values": {"root_module": {"resources": [{
        "address": "aiven_redis.dewan-redis-terraform",
        "mode": "managed",
        "type": "aiven_redis",
        "name": "backend-redis-terraform",
        "provider_name": "registry.terraform.io/aiven/aiven",
        "schema_version": 1,
        "values": {
            "cloud_name": "google-northamerica-northeast1",
            "plan": "hobbyist",
            "project": "devrel",
            "service_name": "crab_cast",
            "service_type": "redis",
        },
    }]}}}
}

test_deny_project_name {
	not analysis.allow_project_name with input as {"planned_values": {"root_module": {"resources": [{
		"address": "aiven_redis.redis-demo",
		"mode": "managed",
		"type": "aiven_redis",
		"name": "redis-demo",
		"provider_name": "registry.terraform.io/aiven/aiven",
		"schema_version": 1,
		"values": {
			"cloud_name": "google-northamerica-northeast1",
			"plan": "hobbyist",
			"project": "sales-dewan",
			"service_name": "redis-demo",
			"service_type": "redis",
		},
	}]}}}
}

test_deny_service_name {
	not analysis.allow_service_name with input as {"planned_values": {"root_module": {"resources": [{
		"address": "aiven_redis.redis-demo",
		"mode": "managed",
		"type": "aiven_redis",
		"name": "redis-demo",
		"provider_name": "registry.terraform.io/aiven/aiven",
		"schema_version": 1,
		"values": {
			"cloud_name": "google-northamerica-northeast1",
			"plan": "hobbyist",
			"project": "devrel-dewan",
			"service_name": "redis-demo-12345",
			"service_type": "redis",
		},
	}]}}}
}

```

