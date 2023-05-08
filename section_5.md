# Section five 

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
