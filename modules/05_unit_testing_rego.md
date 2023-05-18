# Section five 

Now that we have a few policies in place, we are going to add unit tests to ensure our policies are good before we enforce them in production.

Create a rego file for our tests. 

file `policy/test_terraform.rego`:

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

```
Bonus points for writing this with the DRY (Don't Repeat Yourself) coding practices.

## Running the tests

With our testing file in place let's run the tests. In this command we are calling the OPA binary, with the subcommand test on the target folder policy.

```bash
opa test policy
```

## Challenge add unit tests for the additional policy rules you created

test_project_name {
    # insert code here
}

test_service_name {
    # insert code here
}
