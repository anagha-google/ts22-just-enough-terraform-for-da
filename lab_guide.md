### 1. Clone the repo
1.1. Run this on Cloud Shell
```
cd ~
git clone https://github.com/anagha-google/ts22-just-enough-terraform-for-da.git
cd ts22-just-enough-terraform-for-da
```

<hr>

### 2. Configure your preferences in the preferences script

2.1. Edit the file configure.sh under 00-setup for your preferences.<br>
E.g. Update the GCP region and zone to match your preference.<br>

```
cd ~/ts22-just-enough-terraform-for-da/00-setup
vi configure-preferences.sh
```

### 3. Run the preferences shell script

3.1. Run the command below in Cloud shell-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
./configure-preferences.sh
```

3.2. This creates a variables file called terraform.tfvars that will be used for the rest of the lab. Lets review the file.<br>
Run the command below in Cloud shell-
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/terraform.tfvars
```

Here is the author's output-
```
project_id = "ts22-lab"
project_number = "1053xx529"
project_name = "ts22-lab"
gcp_account_name = "xxxxx@akhanolkar.altostrat.com"
org_id = "23xxx571"
bq_connector_jar_gcs_uri = "gs://spark-lib/bigquery/spark-bigquery-with-dependencies_2.12-0.22.2.jar"
cloud_composer_image_version = "composer-2.0.11-airflow-2.2.3"
gcp_region = "us-central1"
gcp_zone = "us-central1-a"
gcp_multi_region = "US"
provision_vertex_ai = "true"
update_org_policies = "true"

```

<hr>

### 4. Initialize Terraform

4.1. Run the init command in Cloud Shell-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
```
You will see some output in the console. <br>

4.2. Check the directory to see what got created there.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
ls -al
```

Author's output is-
```
-rwxr-xr-x  1 admin_ admin_ 1645 Oct 24 16:37 configure-preferences.sh
-rw-r--r--  1 admin_ admin_ 2869 Oct 24 16:19 main.tf
drwxr-xr-x  2 admin_ admin_ 4096 Oct 24 16:08 module_apis_and_policies
drwxr-xr-x  4 admin_ admin_ 4096 Oct 24 16:49 **.terraform**
-rw-r--r--  1 admin_ admin_ 3335 Oct 24 16:49 **.terraform.lock.hcl**
-rw-r--r--  1 admin_ admin_  460 Oct 24 16:38 terraform.tfvars
-rw-r--r--  1 admin_ admin_  876 Oct 24 16:20 variables.tf
-rw-r--r--  1 admin_ admin_  263 Oct 24 15:06 versions.tf
```

<hr>

### 5. Review the Terraform execution plan

Terraform Hashicorp Configuration Language (HCL) is declarative (and not imperative). When you run the plan, it studies the configuration and comes up with an execution plan. Review the plan in Cloud Shell.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform plan
```

Study the output and see the number of resources provisioned.

<hr>

### 6. Provision with Terraform - modularized enabling of Google APIs and Organization Policy updates

1. At the onset of the lab, we will just enable Google APIs and (optionally) update org policies. <br>
2. The boolean for updating the org policies is in the terraform.tfvars. Google Customer engineers need to update org policies in their designated environments, but this is not applicable for everyone. Set the boolean to false in the tfvars file if you dont need to org policies in your environment.<br>
3. Study the main.tf in the root directory

Open the main.tf as show below -

```
cat ~/ts22-just-enough-terraform-for-da/00-setup/main.tf
```

You should see a bunch of variables declared and then the below. Review the difference between local.<variable> and var.<variable>.
 
```
module "setup_foundations" {
    source = "./module_apis_and_policies"
    project_id = var.project_id
}
```

When the main.tf executes, it processes the variables declared and then runs the step above, and essentially iterates into the directory "module_apis_and_policies" and runs the main.tf there.

Review the module .tf file-
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/module_apis_and_policies/main.tf
```
It enables a bunch of APIs and depending on the boolean for updateing org policies, updates the same (or not)


4. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform apply --auto-approve
```
In case your are wondering where the variables are supplied, Terraform reads them from terraform.tfvars.
<br>

Terraform will enable the APIs and Org policies with as much parallelism as possible. Notice the "sleep" statements in the main.tf in the module. The reason for this is both API enabling and Org policy updates are async and return immediately after issuing the commands behind the scenes. This can cause issues if we run the next steps and if they are dependent on API enabling for example and if they have not completed.
  
5. Observe the output<br>
```
 .........
module.setup_foundations.time_sleep.sleep_after_api_enabling: Still creating... [2m50s elapsed]
module.setup_foundations.time_sleep.sleep_after_api_enabling: Still creating... [3m0s elapsed]
module.setup_foundations.time_sleep.sleep_after_api_enabling: Creation complete after 3m0s [id=2022-10-24T17:38:28Z]

Apply complete! Resources: 19 added, 0 changed, 0 destroyed.
```
 
6. Review the execution of the declarations in the module.

<hr>
 
### 7. Terraform state
 
When you ran the "terraform apply" command in #6, Terraform completed the action and persisted state locally. A best practice is to use a GCS bucket for state for multiple reasons - reslience, collaboration (team updates) and more. For the purpose of simplicity, we will persist state locally.
 
1. Review the state file location by running the command below-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
ls -al
```
Note what is new.<br>
 
2. Run the "terraform apply" command you ran previously again and observe the output
 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform apply --auto-approve
```
 
Terraform will just say-
```
No changes. Your infrastructure matches the configuration.
Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
```
 
<hr>
 
### 8. IAM: Creation of user managed service account and IAM role granting

1. Move the file iam.tf as shown below to the Terraform root directory
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/iam.tf .
```
2. Open the file and read its contents
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/iam.tf
```
a) It first creates a user managed service account (UMSA),
b) It then grants the UMSA IAM roles
c) It also grants Google Managed Service accounts for specific services, roles as required by the services
d) It then grants the admin user impersonation privileges on the UMSA
e) For the rest of the lab, all services will be provisioned as the UMSA
 
3. Terraform will run every .tf file in the root directory when an "apply" is issued.
4. Run "terraform apply" command you ran previously again and observe the output
 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
In the end, you should see-
 ```
 Apply complete! Resources: 42 added, 0 changed, 0 destroyed.
 ```
 
5. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
6. Validate the provisioning by going to Cloud Console -> IAM 
 
<hr>

### 9. Networking: Creation of VPC, Subnet, Firewall rule(s), reservered IP, VPC peering
 
In this section, we will provision networking entities needed for VPC native services/those that support BYO VPC - such as Cloud Dataproc, Cloud Composer, Cloud Dataflow, Vertex AI Workbench. <br>
 
1. Move the file network.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/network.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/network.tf
```
a) It first creates VPC,<br>
b) And a subnet with Private Google Access<br>
c) It creates a specific firewall rule<br>
d) It creates a reserved IP needed for Vertex AI workbench, for BYO network<br>
e) It creates peers the network with the Google tenant network - again, needed for Vertex AI workbench, for BYO network<br>
 
4. Terraform will incrementally run every .tf file in the root directory and any updates to teh same when an "apply" is issued. It will therefore run the network.tf<br>
5. Observe the output in the other tab<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
6. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
7. Validate the provisioning by going to Cloud Console -> Networking 
 
<hr>
 
### 10. Storage: Creation buckets
 
In this section, we will provision GCS buckets for Spark, dataproc, code, data, notebooks. <br>
 
1. Copy the file storage.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/storage.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/storage.tf
```
It creates the various buckets<br>
 
4. Terraform will incrementally run every .tf file in the root directory and any updates to teh same when an "apply" is issued. It will therefore run the network.tf<br>
 
5. Observe the output in the other tab<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
6. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
7. Validate the provisioning by going to Cloud Console -> Storage

<hr>
