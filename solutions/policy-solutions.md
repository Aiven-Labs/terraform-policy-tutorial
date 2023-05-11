### Solutions to the policy exercise

Here's the `terraform.rego` that includes policies to enforce the following requirements:

- project must start with team name
- service_name must include app name

```rego
package terraform.analysis

import input as tfplan
import future.keywords

resource_types := {"aiven_kafka", "aiven_pg", "aiven_opensearch", "aiven_redis"}

default allow_dev_deployment := false

default allow_prod_deployment := false

default allow_project_name := false

default allow_service_name := false

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

allow_project_name {
    project_name := tfplan.variables.project_name.value
    startswith(project_name, data.team)
}

allow_service_name {
    some resource in tfplan.planned_values.root_module.resources
    resource.type in resource_types
	contains(resource.values.service_name, data.app)
}
```

> **Note** you may have noticed that there is no explicit if keyword in the `allow_project_name` or `allow_service_name` policy. This is because in Rego, the presence of a rule implies a condition that must be satisfied for the rule to be true. In other words, a rule is equivalent to an if statement in other programming languages.

> So in this case, the `allow_project_name` policy is true if and only if the `project_name` defined in the Terraform manifest starts with the team name defined in the `data.json` file. There is no need for an explicit if statement because the condition is implied by the rule itself. 