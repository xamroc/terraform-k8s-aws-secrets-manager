# terraform-k8s-aws-secrets-manager

# Commands
## Display secret
```
kubectl exec -it $(kubectl get pods | awk '/nginx-deployment/{print $1}' | head -1) cat /mnt/secrets-store/cluster-aws-secrets-manager_team-red_secret; echo
````

## Error
```
Events:
  Type     Reason       Age                From               Message
  ----     ------       ----               ----               -------
  Warning  FailedMount  39s                kubelet            MountVolume.SetUp failed for volume "secrets-store-inline" : rpc error: code = Unknown desc = failed to mount secrets store objects for pod team-blue/nginx-deployment-8567c79cf6-qgb6d, err: rpc error: code = Unknown desc = Failed fetching secret cluster-aws-secrets-manager/team-red/secret: AccessDeniedException: User: arn:aws:sts::xxx:assumed-role/cluster-aws-secrets-manager-team-blue-secrets-manager-role/secrets-store-csi-driver-provider-aws is not authorized to perform: secretsmanager:GetSecretValue on resource: cluster-aws-secrets-manager/team-red/secret because no identity-based policy allows the secretsmanager:GetSecretValue action
           status code: 400, request id: xxx
```
