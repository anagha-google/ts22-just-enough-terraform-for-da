### 1. Clone the repo
Run this on Cloud Shell
```
cd ~
git clone https://github.com/anagha-google/ts22-just-enough-terraform-for-da.git
cd ts22-just-enough-terraform-for-da
```

### 2. Configure your preferences in the preferences script

Edit the file configure.sh under 00-setup for your preferences.<br>
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

Run the init command in Cloud Shell-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
```

You will see some output in the console. <br>
Check the directory to see what got created there.

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
ls -al
```
