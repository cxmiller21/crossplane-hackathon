# Crossplane Hackathon Project

## Project Description

Leverage Kubernetes, Crossplane, and ArgoCD to create and manage AWS infrastructure with GitOps.

### High Level Goals

1. Create a local Kubernetes cluster with [kind](https://kind.sigs.k8s.io/)
2. Install ArgoCD on the cluster
3. Install Crossplane on the cluster
4. Have ArgoCD provide a GitOps workflow for managing AWS Crossplane resources

## Pre-requisites

- An AWS Account with access keys that can be used by Crossplane
  - This could be an admin account or a new user with limited permissions to AWS S3, IAM, and Lambda
- [Docker](https://docs.docker.com/get-docker/)
  - The "Enable Kubernetes" setting in Docker Desktop is **not required**
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
  - On Mac - `brew install kind`
- [Go](https://golang.org/doc/install)
  - On Mac - `brew install go`
- A git repo with an SSH key configured for ArgoCD
  - [GitHub](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)
  - [GitLab](https://docs.gitlab.com/ee/ssh/)
  - [Bitbucket](https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/)
- Something else?

## Getting Started

### Update Project variables

Create an `aws-credentials.txt` file in the root of the project with the following contents:

```txt
[default]
aws_access_key_id = x
aws_secret_access_key = x
```

**Required**

- ./manifests/argocd/application.yaml
  - source.repoURL (In SSH format if using SSH)
    - git@<site>.com:<user>/repo-name.git
- ./manifests/project/lambda-function.yaml
  - s3Bucket
- ./manifests/project/s3-bucket.yaml
  - metadata.name (S3 bucket name)
- ./scripts/create-aws-resources.sh
  - AWS_S3_BUCKET_NAME
- ./scripts/zip-and-upload-lambda-code.sh
  - AWS_CLI_PROFILE
  - AWS_S3_BUCKET_NAME
- ./scripts/clean-up.sh
  - AWS_CLI_PROFILE
  - AWS_S3_BUCKET_NAME

**Optional**

- ./manifests/project/lambda-function.yaml
  - SLACK_WEBHOOK_URL
  - SLACK_CHANNEL

### Create the Cluster + Install ArgoCD and Crossplane

```bash
# Create local Kubernetes cluster with kind and install ArgoCD
./scripts/set-up-cluster-and-argocd.sh
# Copy the password that's output by the script
# Open localhost:8080 and login to ArgoCD UI

# Open a new terminal window and set up Crossplane
./scripts/set-up-crossplane.sh
```

### Create the AWS Resources

```bash
./scripts/create-aws-resources.sh
# View the created resources in the AWS Console
```

## Configure ArgoCD for GitOps

```bash
# Push the project to your git repo
git add .
git commit -m "Initial commit"
git push

# Configure ArgoCD to sync with your git repo
# In the ArgoCD UI go to Settings > Repositories > Add/New
# Fill in the details for your git repo and
# add the private key to ArgoCD > Settings > Repositories
# Click "Create" and you should see your repo successfully linked in ArgoCD

# Create the ArgoCD Application
k create -f ./manifests/argocd/application.yaml

# View the new application in the ArgoCD UI
```

At this point, you should be able to make a change to files in the ./manifests/project directory and see the changes automatically synced with ArgoCD and reflected in the AWS Console.

## Clean Up

```bash
./scripts/clean-up.sh
```
