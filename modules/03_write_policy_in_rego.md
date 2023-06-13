# Section three 

OPA policies are written in [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/). The following Rego checks if Rapu can deploy to a development environment or a production environment based on the type of Terraform resource and the cloud region they choose. 

In the same folder, create a sub-folder called **policy** and create a file within called **terraform.rego**. Add the following code to that file:

`terraform.rego` file:

```rego
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
	startswith(resource.values.cloud_name, dev_env_cloud_prefix)
}

allow_prod_deployment if {
	some resource in tfplan.planned_values.root_module.resources
	resource.type in resource_types
	startswith(resource.values.cloud_name, prod_env_cloud_prefix)
}
```

Let's analyze this file. Crab Inc. uses PostgreSQL for their relational database, Redis for caching, OpenSearch for search and analytics, and Kafka as the central message bus. Therefore, `resource_types` field limits the use of these four resources only. Crab Inc. allows developers to deploy only in the Montreal, Canada region and `dev_env_cloud_prefix` field takes care of that requirement. Similarly, production deployments are allowed at any one of Aiven's supported AWS cloud regions in the USA East coast which `prod_env_cloud_prefix` field takes care of.

Execute the following command from the main directory to find out if OPA would allow the Terraform deployment to go through:

```shell
./opa exec --decision terraform/analysis/allow_prod_deployment --bundle policy/ tfplan.json
```

With the current Terraform service definition, the output of the above command will be:

```shell
{
  "result": [
    {
      "path": "tfplan.json",
      "result": false
    }
  ]
}
```

If you have [jq](https://stedolan.github.io/jq) installed on your machine, you can find the exact result with:

```shell
./opa exec --decision terraform/analysis/allow_prod_deployment --bundle policy/ tfplan.json | jq '.result[0].result'
```

The `opa exec` command is taking in the `tfplan.json` as an input and validating this against the policy we defined in the **allow_prod_deployment** section under policy/terraform.rego file. **terraform/analysis** is denoting the package name in that Rego. 

Let's make a change in the `services.tf` file and change the `cloud_name` field to `aws-us-east1`. Now if you repeat steps 2, 3, and 4, the output from the `opa exec` command should be `true`.

hint:

```bash
terraform plan --out tfplan.binary
terraform show -json tfplan.binary | jq > tfplan.json
opa exec --decision terraform/analysis/allow_prod_deployment --bundle ./policy tfplan.json
```