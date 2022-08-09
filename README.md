# Terraform for AWS Secrets Manager and Kubernetes (K8s) Namespaces

## Description

Showcase how we can use K8s Namespaces as a logical grouping to restrict access to secrets in AWS Secrets Manager.

## Prerequisites
1. Terraform >= 1.x.x
2. Secret in AWS Secrets Manager named: `cluster-aws-secrets-manager/team-red/secret`

## Commands
### Plan
```
terraform plan
```

### Apply
```
terraform apply
```

### Deploy Sample Code
```
kubectl apply -f ./examples/k8s-manifests/secrets-provider-class.yaml -n team-red
kubectl apply -f ./examples/k8s-manifests/deployment.yaml -n team-red
```

### Display Secret
```
kubectl exec -it $(kubectl get pods | awk '/nginx-deployment/{print $1}' | head -1) cat /mnt/secrets-store/cluster-aws-secrets-manager_team-red_secret; echo
````
