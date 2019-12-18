# 创建 SA 和 secret
```text
1. 创建 sa
kubectl create sa -n kube-system kubernetes-dashboard

2. 创建 secret
kubectl create secret tls kubernetes-dashboard-certs -n kube-system --key <your-ingress-host-ssl-private-key> --cert <your-ingress-host-ssl-cert>
```

# 设置 kubernetes-dashboard kubeconfig
```text
# 获取 token
dashboard_token=$(kubectl -n kube-system get secret <your-kubernetes-dashboard-token-name> -o yaml  | grep 'token:' | awk '{print $2}' | base64 -d)

# 设置集群参数
kubectl config set-cluster kubernetes \
    --server=<your-kubernetes-apiserver-address-and-port> \
    --certificate-authority=<your-ca-cert> \
    --embed-certs=true \
    --kubeconfig=kubernetes-dashboard.kubeconfig

# 设置客户端参数
kubectl config set-credentials kubernetes-dashboard-admin \
    --token=$dashboard_token \
    --kubeconfig=kubernetes-dashboard.kubeconfig


# 设置上下文参数
kubectl config set-context kubernetes-dashboard \
    --cluster=kubernetes \
    --user=kubernetes-dashboard-admin \
    --kubeconfig=kubernetes-dashboard.kubeconfig

# 设置默认的上下文
kubectl config currect-context kubernetes-dashboard --kubeconfig=kubernetes-dashboard.kubeconfig
```
