### 13. Dataproc: Create a persistent Spark History Server
 
In this section, we will create a persistent Spark History Server that can be used by Dataproc GCE cluster, the Dataproc Servreless Spark notebooks in the lab
 
1. Copy the file phs.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/phs.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/phs.tf
```
It first creates a Dataproc cluster and uses a bucket specified, uses the subnet created.
 
4. Observe the output.<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```
 
6. Once again, we ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.

7. Validate the provisioning by going to Cloud Console -> Dataproc

8. Run through these steps in the Dataproc GUI
a) Click on the cluster you see under "Clusters"<br>
b) Click on the Web Interfaces<br>
c) Click on "Spark History Server"<br>
We will use this later in the lab.<br>

<hr>


