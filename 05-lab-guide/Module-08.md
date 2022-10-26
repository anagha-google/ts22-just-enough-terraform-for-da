# Module 8: Create Dataproc Persistent Spark History Server
 
In this section, we will create a persistent Spark History Server that can be used by Dataproc GCE cluster, the Dataproc Servreless Spark notebooks in the lab. The persistent History Server provides centralized log storage with no retention period and a centralized Spark UI for Spark applications run across staic and ephemeral Spark infrastuctures (Spark on dataproc GCE, GKE, and Dataproc Serverless Spark).


**Lab Module Duration:** <br>
5 minutes 

<hr>

## 1. Copy the TF file for Persistent Spark History Server into the Terraform root directory
Copy the file phs.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/phs.tf .
```

<hr>

## 2. Layout of the Terraform root directory
```
~/ts22-just-enough-terraform-for-da/00-setup

           ....module_apis_and_policies
           ....shelf

           ....main.tf
           ....variables.tf
           ....versions.tf
           ....terraform.tfvars 
           
           ....iam.tf
           ....network.tf    
           ....storage.tf 
           ....bigquery.tf
           
           ....phs.tf <--- WE ARE HERE
           
```

<hr>

## 3. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
 <hr>
 
## 4. Study the terraform
In a separate Cloud Shell tab-
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/phs.tf
```

It first creates a Dataproc cluster and uses a bucket specified, uses the subnet created.<br><br>

Observe the output-<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
 ```
 
 <hr>
 
## 5. Validate
Validate the provisioning by going to Cloud Console -> Dataproc.<br>
Run through these steps in the Dataproc GUI-
a) Click on the cluster you see under "Clusters"<br>
b) Click on the Web Interfaces<br>
c) Click on "Spark History Server"<br>
We will use this later in the lab.<br>


<hr>

 This concludes the module. Please proceed to the [next module](Module-09.md).

<hr>
