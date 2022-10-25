variable "project_id" {
  type        = string
  description = "project id required"
}
variable "update_org_policies_bool"{
 description = "Boolean for editing organization policies"
 type = bool
 default = true
}