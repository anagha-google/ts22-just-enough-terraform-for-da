variable "project_id" {
  type        = string
  description = "project id"
}
variable "project_name" {
 type        = string
 description = "project name"
}
variable "project_number" {
 type        = string
 description = "project number"
}
variable "gcp_account_name" {
 description = "Your user ID"
}
variable "org_id" {
 description = "Organization ID in which project exists"
}
variable "cloud_composer_image_version" {
 description = "Version of Cloud Composer 2 image to use"
}
variable "gcp_region" {
 description = "GCP region"
}
variable "gcp_zone" {
 description = "GCP zone"
}
variable "gcp_multi_region" {
 description = "GCP multi-region"
}
variable "bq_connector_jar_gcs_uri" {
 description = "BQ connector jar to use"
}
variable "provision_vertex_ai_bool" {
 description = "Boolean for provisioning Vertex AI Workbench for notebooks"
 type = bool
 default = true
}
variable "update_org_policies_bool" {
 description = "Boolean for editing organization policies"
 type = bool
 default = true
}
