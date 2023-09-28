resource "shoreline_notebook" "high_container_volume_usage_incident_for_ecs" {
  name       = "high_container_volume_usage_incident_for_ecs"
  data       = file("${path.module}/data/high_container_volume_usage_incident_for_ecs.json")
  depends_on = [shoreline_action.invoke_check_volume_usage,shoreline_action.invoke_modify_ebs_volume_size]
}

resource "shoreline_file" "check_volume_usage" {
  name             = "check_volume_usage"
  input_file       = "${path.module}/data/check_volume_usage.sh"
  md5              = filemd5("${path.module}/data/check_volume_usage.sh")
  description      = "A sudden spike in user traffic causing an unexpected increase in the container's volume usage."
  destination_path = "/agent/scripts/check_volume_usage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "modify_ebs_volume_size" {
  name             = "modify_ebs_volume_size"
  input_file       = "${path.module}/data/modify_ebs_volume_size.sh"
  md5              = filemd5("${path.module}/data/modify_ebs_volume_size.sh")
  description      = "Increase the storage capacity of the container volume to accommodate the growing data."
  destination_path = "/agent/scripts/modify_ebs_volume_size.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_volume_usage" {
  name        = "invoke_check_volume_usage"
  description = "A sudden spike in user traffic causing an unexpected increase in the container's volume usage."
  command     = "`chmod +x /agent/scripts/check_volume_usage.sh && /agent/scripts/check_volume_usage.sh`"
  params      = ["CLUSTER_NAME","INSTANCE_ID","CONTAINER_NAME"]
  file_deps   = ["check_volume_usage"]
  enabled     = true
  depends_on  = [shoreline_file.check_volume_usage]
}

resource "shoreline_action" "invoke_modify_ebs_volume_size" {
  name        = "invoke_modify_ebs_volume_size"
  description = "Increase the storage capacity of the container volume to accommodate the growing data."
  command     = "`chmod +x /agent/scripts/modify_ebs_volume_size.sh && /agent/scripts/modify_ebs_volume_size.sh`"
  params      = ["EBS_VOLUME_ID"]
  file_deps   = ["modify_ebs_volume_size"]
  enabled     = true
  depends_on  = [shoreline_file.modify_ebs_volume_size]
}

