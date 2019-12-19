# cert-manager

[官方文档](https://cert-manager.io/docs/)

* 安装

[Kubernetes平台安装](https://cert-manager.io/docs/installation/kubernetes/)

[备用 image](https://hub.docker.com/r/bitnami/cert-manager)

```bash
1. 创建命名空间
kubectl create namespace cert-manager

2. 应用资源
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.12.0/cert-manager.yaml 
```

