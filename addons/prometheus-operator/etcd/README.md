# 创建 etcd-secret
```bash
kubectl -n monitoring create secret generic etcd-secret --from-file=etcd-ca=/data/kubernetes/certs/ca/ca.pem --from-file=etcd-cert=/data/kubernetes/certs/etcd/etcd.pem --from-file=etcd-key=/data/kubernetes/certs/etcd/etcd-key.pem
```

# ETCD
导入编号为3070的模板。
