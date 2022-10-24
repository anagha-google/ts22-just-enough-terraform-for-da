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
project_id                  = "${var.project_id}"
project_nbr                 = "${var.project_number}"
admin_upn_fqn               = "${var.gcp_account_name}"
location                    = "${var.gcp_region}"
zone                        = "${var.gcp_zone}"
location_multi              = "${var.gcp_multi_region}"
umsa                        = "s8s-lab-sa"
umsa_fqn                    = "${local.umsa}@${local.project_id}.iam.gserviceaccount.com"
s8s_spark_bucket            = "s8s-spark-bucket-${local.project_nbr}"
s8s_spark_bucket_fqn        = "gs://s8s-spark-${local.project_nbr}"
s8s_spark_sphs_nm           = "s8s-sphs-${local.project_nbr}"
s8s_spark_sphs_bucket       = "s8s-sphs-${local.project_nbr}"
s8s_spark_sphs_bucket_fqn   = "gs://s8s-sphs-${local.project_nbr}"
vpc_nm                      = "s8s-vpc-${local.project_nbr}"
spark_subnet_nm             = "spark-snet"
spark_subnet_cidr           = "10.0.0.0/16"
psa_ip_length               = 16
s8s_data_bucket             = "s8s_data_bucket-${local.project_nbr}"
s8s_code_bucket             = "s8s_code_bucket-${local.project_nbr}"
s8s_notebook_bucket         = "s8s_notebook_bucket-${local.project_nbr}"
s8s_model_bucket            = "s8s_model_bucket-${local.project_nbr}"
s8s_bundle_bucket           = "s8s_bundle_bucket-${local.project_nbr}"
s8s_pipeline_bucket         = "s8s_pipeline_bucket-${local.project_nbr}"
s8s_metrics_bucket          = "s8s_metrics_bucket-${local.project_nbr}"
s8s_functions_bucket        = "s8s_functions_bucket-${local.project_nbr}"
s8s_artifact_repository_nm  = "s8s-spark-${local.project_nbr}"
bq_datamart_ds              = "customer_churn_ds"
bq_datamart_sample_table    = "planboundaries"
umnb_server_machine_type    = "e2-medium"
umnb_server_nm              = "s8s-spark-ml-pipelines-nb-server"
mnb_server_machine_type     = "n1-standard-4"
mnb_server_nm               = "s8s-spark-ml-interactive-nb-server"
CC_GMSA_FQN                 = "service-${local.project_nbr}@cloudcomposer-accounts.iam.gserviceaccount.com"
GCE_GMSA_FQN                = "${local.project_nbr}-compute@developer.gserviceaccount.com"
CLOUD_COMPOSER2_IMG_VERSION = "${var.cloud_composer_image_version}"
SPARK_CONTAINER_IMG_TAG     = "${var.spark_container_image_tag}"
dpms_nm                     = "s8s-dpms-${local.project_nbr}"
bq_connector_jar_gcs_uri    = "${var.bq_connector_jar_gcs_uri}"
cloud_scheduler_timezone    = "${var.cloud_scheduler_time_zone}"
}

/******************************************
DONE
******************************************/
module "setup_project" {
    source = "./module-project"
    project_id = var.project_id
}