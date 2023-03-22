#!/bin/bash

echo "Creating local kubernetes cluster"
kind create cluster --name crossplane-cluster

echo "Installing ArgoCD on Kubernetes Cluster"
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

argocd login --core
kubectl config set-context --current --namespace=argocd
argocd cluster add $(kubectl config get-contexts -o name | grep kind)

echo "Waiting for ArgoCD to be ready"
sleep 15

echo "ArgoCD is now available at http://localhost:8080"
echo "Username: admin"
echo "Password: $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)"
kubectl port-forward svc/argocd-server -n argocd 8080:443
