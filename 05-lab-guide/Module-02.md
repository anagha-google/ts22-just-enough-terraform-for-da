# Module 2: Enable Google APIs and update Organization Policies

1. At the onset of this lab (not just this module), we will just enable Google APIs and (optionally) update org policies. <br>
2. We will review the Terraform scripts, commands, state
3. And proceed to the next module

**Note:** <br>
The boolean for updating the org policies is in the terraform.tfvars. Google Customer engineers **need to** update org policies (default=true) in their designated environments, but this is not applicable for everyone. Set the boolean to false in the tfvars file if you dont need to org policies in your environment.<br>

**Lab Module Duration:** <br>
< 5 minutes 

## 1. Layout of the lab repo
The following is the layout-<br>
```
~/ts22-just-enough-terraform-for-da
         00-setup
         01-datasets
         02-scripts
         03-notebooks
         04-templates
         05-lab-guide
         README.md
```
         
## 2. Scripts we will use/review in the Terraform root directory  

```
~/ts22-just-enough-terraform-for-da/00-setup

           ....module_apis_and_policies
               ....main.tf     <---- We will run this
               ....variables.tf
               
           ....shelf
           
           ....main.tf
           ....variables.tf
           ....versions.tf

           ....configure-preferences.sh
           
           ....terraform.tfvars 

```

## 3. Main.tf - review
Study the main.tf in the root directory.<br>
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


## 4. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform apply --auto-approve
```
In case your are wondering where the variables are supplied, Terraform reads them from terraform.tfvars.
<br>

Terraform will enable the APIs and Org policies with as much parallelism as possible. Notice the "sleep" statements in the main.tf in the module. The reason for this is both API enabling and Org policy updates are async and return immediately after issuing the commands behind the scenes. This can cause issues if we run the next steps and if they are dependent on API enabling for example and if they have not completed.
  
## 5. Observe the output<br>
```
 .........
module.setup_foundations.time_sleep.sleep_after_api_enabling: Still creating... [2m50s elapsed]
module.setup_foundations.time_sleep.sleep_after_api_enabling: Still creating... [3m0s elapsed]
module.setup_foundations.time_sleep.sleep_after_api_enabling: Creation complete after 3m0s [id=2022-10-24T17:38:28Z]

Apply complete! Resources: 19 added, 0 changed, 0 destroyed.
```
 
## 6. Review the execution of the declarations in the module.

<hr>
 
## 7. Terraform state
 
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
 
 This concludes the module. Please proceed to the [next module](Module-03.md).
 
 <hr>
 
