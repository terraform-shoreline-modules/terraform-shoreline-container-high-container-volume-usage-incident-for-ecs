terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_container_volume_usage_incident_for_ecs" {
  source    = "./modules/high_container_volume_usage_incident_for_ecs"

  providers = {
    shoreline = shoreline
  }
}