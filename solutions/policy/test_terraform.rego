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