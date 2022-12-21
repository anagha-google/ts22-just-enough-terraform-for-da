### 14. Dataproc & Dataplex: Create a Dataproc Metastore Service
 
In this section, we will create a Dataproc Metastore Service. This takes roughly 30 minutes to run,

1. Copy the file dpms.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/dpms.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/dpms.tf
```
It first creates a Dataproc cluster and uses a bucket specified, uses the subnet created.
 
4. Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```
 
6. Once again, we ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.

7. Validate the provisioning by going to Cloud Console -> Dataproc

8. Run through these steps in the Dataproc GUI<br>
a) Click on "Metastore" in the left navigation panel<br>
b) Review the deployment<br>


<hr>