# Module 19: Other helpful Terraform commands
In this module, we will about replace, rerun and destroy
<br>

**Lab Module Duration:** <br>
2 minutes to review
25 minutes to destroy environment 


## 1. Replacing/re-run a pre-created resource

```
terraform apply -replace=google_storage_bucket_object.upload_cc2_dag_to_airflow_dag_bucket
```
Or
```
terraform apply -target=google_storage_bucket_object.upload_cc2_dag_to_airflow_dag_bucket
```

## 2. Destroy the deployment

```
cd ~/ts22-just-enough-terraform-for-da/00-setup/
terraform destroy
```

Our Terraform providers can be glitchy. Consider shutting down the project if possible.

<hr>

This concludes the lab. There is a tip in the next/last [module](Module-20.md) where you will learn (just informational) to run the entire provisioning in one shot. DONT forget to delete the resources created in the lab.

<hr>
