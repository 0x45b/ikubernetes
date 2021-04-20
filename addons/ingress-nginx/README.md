# 下载最新的配置

到下面的网站找到 URL 下载最新的编排文件：
https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal

# 修改部分

```yaml
kind: DaemonSet

dnsPolicy: ClusterFirstWithHostNet
hostNetwork: true
tolerations:
  - key: node-role.kubernetes.io/master
    operator: Exists

nodeSelector:
  kubernetes.io/os: linux
  ingress-controller: nginx
```
