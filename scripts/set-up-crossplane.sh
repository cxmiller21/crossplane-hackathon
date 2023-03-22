#!/bin/bash

echo "Downloading and installing Crossplane Helm Charts"
helm repo add crossplane-stable https://charts.crossplane.io/stable
helm repo update

helm install crossplane \
  crossplane-stable/crossplane \
  --namespace crossplane-system \
  --create-namespace

echo "Crossplane pods"
kubectl get pods -n crossplane-system

echo "Installing Crossplane AWS Provider"
kubectl create -f ./manifests/cluster/crossplane-aws-provider.yaml
kubectl wait --for=condition=Installed --timeout=180s provider upbound-provider-aws
kubectl wait --for=condition=Healthy --timeout=180s provider upbound-provider-aws
kubectl get providers

echo "Creating Kubernetes secret for AWS access keys to Crossplane"
kubectl create secret \
  generic aws-secret \
  -n crossplane-system \
  --from-file=creds=./aws-credentials.txt

kubectl describe secret aws-secret -n crossplane-system

echo "Creating Crossplane AWS Provider Configuration"
# This attaches the AWS credentials, saved as a Kubernetes secret, as a secretRef
kubectl create -f ./manifests/cluster/provider-config.yaml
