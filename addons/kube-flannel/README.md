# 下载最新的kube-flannel编排文件
```shell
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml -O kube-flannel.yml
```


# 注意事项
```text
1. 修改 ConfigMap 中的net-conf.json字段的 Network 字段为你的 --cluster-cidr 所定义的值。
```

```shell
/bin/bash sed.sh <YOUR-CLUASTER-CIDR>
```
