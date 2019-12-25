# 执行顺序

```text
0. 首先部署 nginx 和 keepalived 负载均衡
1. 在每个节点执行 k8s-init.sh，执行初始化，并安装 docker 和 kubelet
2. 在第一台 master 节点执行初始化命令：kubeadm init --config kubeadm-config.yaml --upload-certs
3. 在第一台 master 节点应用flannel 配置：kubectl apply -f kube-flannel.yaml
4. 根据提示，将第二台、第三台机器加入集群中
5. 根据提示，将 node 加入到集群中
```
