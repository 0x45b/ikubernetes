[官方仓库](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)

# 需要修改的内容

默认情况下，部署到 `default` namespace下。

* 修改namespace
```shell
NAMESPACE="default"
sed -i'' "s/namespace:.*/namespace: $NAMESPACE/g" ./deploy/rbac.yaml ./deploy/deployment.yaml
```

* 修改 `deployment.yaml`

需要修改如下几个变量 `PROVISIONER_NAME`、`NFS_SERVER`、`NFS_PATH`

> 注意：如果这里修改了 `PROVISIONER_NAME` ，则在定义 `storageclass` 时，也要修改 `provisioner` 为这里所设置的 `PROVISIONER_NAME`


# nfs provisoner参数

```text
1. onDelete
支持两个值：delete和retain。
delete：如果目录已经存在，删除这个目录。
retain：如果目录已经存储，保留这个目录。

2. archiveOnDelete
如果是false，则删除的时候不会归档。如果定义了onDelete，则忽略该参数。

3. pathPattern
使用pvc的元数据创建目录。比如根据label、annotation、name或者namespace来创建。引用metadata：${.PVC.<metadata>}。
如 ${.PVC.name}，${.PVC.namespace}等。
```