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