
### 9. Networking: Creation of VPC, Subnet, Firewall rule(s), reservered IP, VPC peering
 
In this section, we will provision networking entities needed for VPC native services/those that support BYO VPC - such as Cloud Dataproc, Cloud Composer, Cloud Dataflow, Vertex AI Workbench. <br>
 
1. Move the file network.tf as shown below to the Terraform root directory<br>
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
cp shelf/network.tf .
```

2. Run the terraform<br> 
```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform init
terraform apply --auto-approve
```
 
3. While its running, in a separate Cloud Shell tab, open the file and read its contents<br>
```
cat ~/ts22-just-enough-terraform-for-da/00-setup/network.tf
```
a) It first creates VPC,<br>
b) And a subnet with Private Google Access<br>
c) It creates a specific firewall rule<br>
d) It creates a reserved IP needed for Vertex AI workbench, for BYO network<br>
e) It creates peers the network with the Google tenant network - again, needed for Vertex AI workbench, for BYO network<br>
 
4. Terraform will incrementally run every .tf file in the root directory and any updates to teh same when an "apply" is issued. It will therefore run the network.tf<br>
5. Observe the output in the other tab<br>
In the end, you should see-<br>
 ```
Apply complete! Resources: 6 added, 0 changed, 0 destroyed.
 ```
 
6. We ran "terraform init" again as we are using some new GCP providers, everytime you introduce a new provider, you have to run the init command.
7. Validate the provisioning by going to Cloud Console -> Networking 
 
<hr>
 
