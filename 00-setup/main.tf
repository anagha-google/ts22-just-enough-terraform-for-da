/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************
Local variables declaration
 *****************************************/

locals {
resource_prefix             = "ts22-jetfdc"

project_id                  = "${var.project_id}"
project_nbr                 = "${var.project_number}"
admin_upn_fqn               = "${var.gcp_account_name}"
location                    = "${var.gcp_region}"
zone                        = "${var.gcp_zone}"
location_multi              = "${var.gcp_multi_region}"

umsa                        = "${local.resource_prefix}-lab-sa"
umsa_fqn                    = "${local.umsa}@${local.project_id}.iam.gserviceaccount.com"
CC_GMSA_FQN                 = "service-${local.project_nbr}@cloudcomposer-accounts.iam.gserviceaccount.com"
GCE_GMSA_FQN                = "${local.project_nbr}-compute@developer.gserviceaccount.com"
CLOUD_COMPOSER2_IMG_VERSION = "${var.cloud_composer_image_version}"

spark_bucket                = "${local.resource_prefix}-spark-bucket-${local.project_nbr}"
spark_bucket_fqn            = "gs://${local.resource_prefix}-spark-${local.project_nbr}"
sphs_nm                     = "${local.resource_prefix}-sphs-${local.project_nbr}"
sphs_bucket                 = "${local.resource_prefix}-sphs-${local.project_nbr}"
sphs_bucket_fqn             = "gs://${local.resource_prefix}-sphs-${local.project_nbr}"
data_bucket                 = "${local.resource_prefix}_data_bucket-${local.project_nbr}"
code_bucket                 = "${local.resource_prefix}_code_bucket-${local.project_nbr}"
notebook_bucket             = "${local.resource_prefix}_notebook_bucket-${local.project_nbr}"
dataproc_bucket             = "${local.resource_prefix}_dataproc_bucket-${local.project_nbr}"

vpc_nm                      = "${local.resource_prefix}-vpc-${local.project_nbr}"
subnet_nm                   = "${local.resource_prefix}-snet"
subnet_cidr                 = "10.0.0.0/16"
psa_ip_length               = 16
nat_router_name             = "${local.resource_prefix}-nat"

bq_datamart_ds              = "ts22_tf_lab_ds"
bq_connector_jar_gcs_uri    = "${var.bq_connector_jar_gcs_uri}"
bq_connection               = "external_gcs"

umnb_server_machine_type    = "e2-medium"
umnb_server_nm              = "${local.resource_prefix}-notebook-server"
mnb_server_machine_type     = "n1-standard-4"
mnb_server_nm               = "${local.resource_prefix}-managed-notebook-server"

dpms_nm                     = "${local.resource_prefix}-dpms-${local.project_nbr}"
dpgce_nm                    = "${local.resource_prefix}-dpgce-${local.project_nbr}"
dpgce_autoscale_policy_nm   = "dpgce-autoscale-policy-${local.project_nbr}"
}

module "setup_foundations" {
    source = "./module_apis_and_policies"
    project_id = var.project_id
}
