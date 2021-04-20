# 克隆最新代码

```shell
git clone https://github.com/coredns/deployment.git coredns-deployment
```

# 部署
```shell
cd coredns-deployment/kubernetes

# 步骤1：执行 deploy.sh 脚本
/bin/bash deploy.sh -i 172.17.0.10 -s > coredns.yaml

# -i：指定 cluster dns 的 ip 地址
# -s：跳过 kube-dns 的配置转成 coredns。如果集群中没有 kube-dns，可以加上 -s 参数。

# 如果不需要步骤2，则可以直接执行如下命令：
/bin/bash deploy.sh -i 172.17.0.10 -s | kubectl apply -f -

# 步骤2：修改 deployment 中的 replicas。
# 默认情况下，没有定义 replicas，默认的 replicas为1，可以根据需要修改。

# 步骤3：应用配置
kubectl apply -f coredns.yaml
```
