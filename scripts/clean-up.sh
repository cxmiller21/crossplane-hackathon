#!/bin/bash

# Please update these variables before running the script
AWS_CLI_PROFILE="default"
AWS_S3_BUCKET_NAME="crossplane-bucket-"

ZIP_FILE_NAME="crossplane-slack-function.zip"

echo "Cleaning up AWS Resources"
kubectl delete -f ./manifests/project/lambda-function.yaml

sleep 30
kubectl delete -f ./manifests/project/lambda-iam-permissions.yaml

aws s3 rm s3://$AWS_S3_BUCKET_NAME/$ZIP_FILE_NAME --profile $AWS_CLI_PROFILE

kubectl delete -f ./manifests/project/s3-bucket.yaml

echo "Cleaning up Cluster Resources"
kind delete clusters crossplane-demo
