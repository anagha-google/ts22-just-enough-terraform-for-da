#!/bin/bash

#........................................................................
# Purpose: Demonstrate how to run a bash script from Terraform
# About: 
# The script creates a local file based on the arguments and uploads
# the file to GCS
#........................................................................

# Variables
PROJECT_ID=`gcloud config list --format 'value(core.project)'`
GCP_ACCOUNT_NAME=$1
GCP_REGION=$2
TARGET_GCS_BUCKET_URI=$3

echo "Hello ${GCP_ACCOUNT_NAME}, from ${GCP_REGION}" > dummy.txt
gsutil cp dummy.txt $TARGET_GCS_BUCKET_URI

