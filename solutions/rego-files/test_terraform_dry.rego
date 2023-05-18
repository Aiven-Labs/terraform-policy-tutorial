package terraform.test_analysis

import data.terraform.analysis

mock_data := {"planned_values": {"root_module": {"resources": [{
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
			"service_name": "redis-crab_cast",
			"service_type": "redis",
		},
	}]}}}

test_allow_dev_deployment {
	analysis.allow_dev_deployment with input as mock_data
}

test_not_allow_prod_deployment {
	not analysis.allow_prod_deployment with input as mock_data
}

test_allow_project_name {
    analysis.allow_project_name with input as mock_data
}

test_allow_service_name {
    analysis.allow_service_name with input as mock_data
}

test_deny_project_name {
	not analysis.allow_project_name with input as mock_data
		with input.planned_values.root_module.resources as [{"values": {
			"project": "devrel-demo"}}]
}

test_deny_service_name {
	not analysis.allow_service_name with input as mock_data
		with input.planned_values.root_module.resources as [{"values": {
			"service_name": "redis-crab_cast"}}]
}