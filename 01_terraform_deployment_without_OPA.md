# Section one 

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