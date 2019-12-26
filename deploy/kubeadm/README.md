# 安装 K8S 

```text
0. 首先部署 nginx 和 keepalived 负载均衡
1. 在每个节点执行 k8s-init.sh，执行初始化，并安装 docker 和 kubelet
2. 在第一台 master 节点执行初始化命令：kubeadm init --config kubeadm-config.yaml --upload-certs
3. 在第一台 master 节点应用flannel 配置：kubectl apply -f kube-flannel.yaml
4. 根据提示，将第二台、第三台机器加入集群中
5. 根据提示，将 node 加入到集群中
```

# 升级 K8S

```text
1. 升级 kubeadm
首先升级 kubeadm 到你要安装的版本，可以用 aliyun kubernetes yum 仓库。

示例：升级 kubeadm 到1.16.4版本
yum install -y kubeadm-1.16.4

2. 执行升级检查
kubeadm upgrade plan

# 该命令会提示当前版本，以及可用的升级版本。
执行升级计划（升级 master 组件）
# 根据命令提示执行升级命令
kubeadm upgrade apply v1.16.4

# 升级成功会提示：[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.16.4". Enjoy!

3. 升级软件包
# 一个节点一个节点的升级
# 驱逐 pod
kubectl drain <your-node-name> --ignore-daemonsets

# 升级软件包
yum install -y kubelet-1.16.4 kubectl-1.16.4 kubeadm-1.16.4

# 升级 kubelet 的配置(在每个要升级的节点上执行)
kubeadm upgrade node phase kubelet-config --kubelet-version $(kubelet --version | cut -d ' ' -f 2)

4. 重启 kubelet
systemctl daemon-reload
systemctl restart kubelet

5. 设置节点可调度
kubectl uncordon <your-node-name>
```
