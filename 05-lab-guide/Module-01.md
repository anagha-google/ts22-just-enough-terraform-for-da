# Module 1: Setup foundations

In this module, you will get started with Terraform.
1. You will create a project manually
2. Clone the lab Git repo
3. Configure your preferences for the lab
4. Run Terraform init
5. Run Terraform plan and review the same
6. In this module, the entities provisioned are - enabling Google APIs and updating Organization policies. 

**Lab Module Duration:** <br>
5 minutes 

**Prerequisite:** <br>
Create a new project manually for this lab. 

## 1. Clone the repo
Run this on Cloud Shell scoped to the new project you created for the lab.
```
cd ~
git clone https://github.com/anagha-google/ts22-just-enough-terraform-for-da.git
cd ts22-just-enough-terraform-for-da
```

<hr>

## 2. Familiarize yourself with the layout

```
THIS IS FYI - DO NOT EXECUTE
~/ts22-just-enough-terraform-for-da
         00-setup
         01-datasets
         02-scripts
         03-notebooks
         04-templates
         05-lab-guide
         README.md
```
Explore the repo really quick.

## 3. Layout of the Terraform root directory
```
THIS IS FYI - DO NOT EXECUTE
~/ts22-just-enough-terraform-for-da/00-setup
           
           ....module_apis_and_policies
           ....shelf
           
           ....main.tf
           ....variables.tf
           ....versions.tf
           
           ....configure-preferences.sh <--- We will run this 
           
```

## 3. Configure your preferences in the preferences script

Edit the file configure.sh under 00-setup for your preferences.<br>
E.g. Update the GCP region and zone to match your preference.<br>
This is so that you get better performance.<br>
If you are okay with provisioning in us-central1, skip this step.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup
vi configure-preferences.sh
```

## 4. Run the preferences shell script

4.1. Run the command below in Cloud shell-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
./configure-preferences.sh
```

4.2. This creates a variables file called terraform.tfvars that will be used for the rest of the lab. Lets review the file.<br>
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
cloud_composer_image_version = "composer-2.0.29-airflow-2.2.5"
gcp_region = "us-central1"
gcp_zone = "us-central1-a"
gcp_multi_region = "US"
provision_vertex_ai = "true"
update_org_policies = "true"

```

<hr>

## 5. Initialize Terraform

5.1. Run the init command in Cloud Shell-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
```
You will see some output in the console. <br>

5.2. Check the directory to see what got created there.

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

## 6. Review the Terraform execution plan

Terraform Hashicorp Configuration Language (HCL) is declarative (and not imperative). When you run the plan, it studies the configuration and comes up with an execution plan. Review the plan in Cloud Shell.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform plan
```

Study the output and see the number of resources provisioned.

<hr> 

This concludes the module, proceed to the [next module](Module-02.md).

<hr>
