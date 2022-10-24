#!/bin/bash

#........................................................................
# Purpose: Copy existing notebooks to Workbench server Jupyter home dir
# (User-managed notebook server)
#........................................................................

gsutil cp gs://ts22-jetfdc_notebook_bucket-YOUR_PROJECT_NBR/python/*.ipynb /home/jupyter/ 
chown jupyter:jupyter /home/jupyter/* 