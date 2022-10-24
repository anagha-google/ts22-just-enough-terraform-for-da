### 1. Clone the repo
1.1. Run this on Cloud Shell
```
cd ~
git clone https://github.com/anagha-google/ts22-just-enough-terraform-for-da.git
cd ts22-just-enough-terraform-for-da
```

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

### 5. Review the Terraform execution plan

Terraform Hashicorp Configuration Language (HCL) is declarative (and not imperative). When you run the plan, it studies the configuration and comes up with an execution plan. Review the plan in Cloud Shell.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform plan
```

Study the output and see the number of resources provisioned.

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
terraform apply
```
In case your are wondering where the variables are supplied, Terraform reads them from terraform.tfvars.
<br>

Terraform will enable the APIs and Org policies with as much parallelism as possible. Notice the "sleep" statements in the main.tf in the module. The reason for this is both API enabling and Org policy updates are async and return immediately after issuing the commands behind the scenes. This can cause issues if we run the next steps and if they are dependent on API enabling for example and if they have not completed.
  
5. Observe the output<br>
6. Review the execution of the declarations in the module.
  
  
### 7. Provision with Terraform - Creation of user managed service account and IAM role granting






