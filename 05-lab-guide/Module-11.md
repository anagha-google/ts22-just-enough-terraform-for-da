# Module 11: (Optional) Run a PySpark notebook on Dataproc Cluster on GCE on a BigLake table
 
In the prior module we created a Dataproc cluster with Jupyter enabled as an optional component, and we uploaded a notebook to the specific GCS path where Jupyter on Dataproc can recognize and make available.<br>

In this module, we will run the notebook, just for the experience of running a Spark notebook in Dataproc on GCE.<br>
The notebook does Icecream Sales Forecasting on a BigLake table.<br> 


**Lab Module Duration:** <br>
- (optional) Ice cream sales forecasting notebook - 5 minutes

## 1. Optional: Run the PySpark Icecream Sales Forecasting notebook
a) On Cloud Console, navigate to the Dataproc UI
b) Click on your cluster (has the keyword dpgce)
c) Go to Web Interfaces in the horizontal menu
d) In the "Web Interfaces" page Click on "JupyterHub".<br>
e) Click on the notebook that opens up and execute the notebook. <br>
f) It reads a Biglake table featuring icecream sales and does sales forecasting using the ML library Prophet. If you recall, we create a router and NAT to allow download of libraries from PyPi in the network module<br>

<hr>

This concludes the module. Proceed to the next module.

<hr>
