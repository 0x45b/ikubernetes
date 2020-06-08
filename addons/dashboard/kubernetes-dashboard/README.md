# 自签明证书
##  创建secret
```text
# 如果用的是 cert-manager，则可以忽略这步。
kubectl create secret tls kubernetes-dashboard-certs -n kubernetes-dashboard --key <your-ingress-host-ssl-private-key> --cert <your-ingress-host-ssl-cert>
```

# 设置 kubernetes-dashboard kubeconfig
```bash
# 设置环境变量
KUBERNETES_APISERVER_ADDRESS="<YOUR-APISERVER-ADDRESS-AND-PORT>"
CA_CERT_PATH="<YOUR-KUBERNETES-APISERVER-CA-CERT>"

# 获取 token
dashboard_token=$(kubectl get secret $(kubectl -n kubernetes-dashboard get secret | grep kubernetes-dashboard-token | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d)

# 设置集群参数
kubectl config set-cluster kubernetes \
    --server=$KUBERNETES_APISERVER_ADDRESS \
    --certificate-authority=$CA_CERT_PATH \
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
kubectl config current-context kubernetes-dashboard --kubeconfig=kubernetes-dashboard.kubeconfig
```
