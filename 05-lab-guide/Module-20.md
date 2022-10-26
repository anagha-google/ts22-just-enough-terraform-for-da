# Module 20: (Optional) Run this lab in one shot

You can run the who lab in one shot if all the .tf files in the shelf directory of 00-setup were in the Terraform root directory. Terraform will review the files and do the necessary dependency management as specified in the individual GCP service specific deployment declaration.

<hr>

## 1. Copy the .tf in shelf/ to the Terraform root directory

Run the below in cloud shell
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
cp -r shelf/* .
```

<hr>

## 2. Edit the preferences script & run it
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
vi configure-preferences.sh
```
Make changes to your GCP region as needed & run it-
```
cd ~/ts22-just-enough-terraform-for-da/00-setup
./configure-preferences.sh
```

<hr>

## 3. Run the Terraform scripts
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```

This could take ~1 hour to complete.

<hr>

## 4. Dont forget to
Shut down the project or run "terraform destroy" to stop the billing.

<hr>
This concludes the lab.
<hr>
