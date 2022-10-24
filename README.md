# Just enough Terraform for Data Analytics on GCP

## About the lab

Anagha TODO


## Start the lab

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
