
# Module 4: Create Network, Subnet, Firewall rule(s), Reserved IP addreess, VPC peering, Router and NAT
 
In this section, we will provision networking entities needed for VPC native services/those that support BYO VPC - such as Cloud Dataproc, Cloud Composer, Cloud Dataflow, Vertex AI Workbench. We will create a router and NAT to allow download of Python packages from PyPi<br>
 
**Lab Module Duration:**
5 minutes 

## 1. Copy the TF file for networking into the Terraform root directory
Copy the file network.tf as shown below to the Terraform root directory

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/network.tf .
```

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
           
           ....network.tf <--- WE ARE HERE
           
```


## 3. Run the terraform
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
## 4. Review the Terraform script
While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/network.tf
```
a) It first creates VPC,<br>
b) And a subnet with Private Google Access<br>
c) It creates a specific firewall rule<br>
d) It creates a reserved IP needed for Vertex AI workbench, for BYO network<br>
e) It creates peers the network with the Google tenant network - again, needed for Vertex AI workbench, for BYO network<br>
f) It then creates a router<br>
g) And a NAT to allow downloads from the internet<br>

Terraform will incrementally run every .tf file in the root directory and any updates to the same when an "apply" is issued. It will therefore run the network.tf<br>
Observe the output in the other tab<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.
 ```

## 5. Again, why "terraform init"?
We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.

## 6. Validate 
Validate the provisioning by going to Cloud Console -> Networking 
 
<hr>

 This concludes the module. Please proceed to the [next module](Module-05.md).

<hr>
 
