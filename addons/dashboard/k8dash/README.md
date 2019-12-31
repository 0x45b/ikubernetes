# 创建RBAC

* apply 配置清单
```bash
kubectl apply -f k8dash-rbac.yaml

kubectl -n kube-system get secret $(kubectl -n kube-system get secret | grep k8dash-sa | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d
```

* 通过命令行创建
```bash
# Create the service account in the current namespace (we assume default)
kubectl create serviceaccount k8dash-sa

# Give that service account root on the cluster
kubectl create clusterrolebinding k8dash-sa --clusterrole=cluster-admin --serviceaccount=default:k8dash-sa

# Find the secret that was created to hold the token for the SA
kubectl get secrets

# Show the contents of the secret to extract the token
kubectl describe secret k8dash-sa-token-xxxxx
```
