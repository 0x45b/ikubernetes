# 创建 secret
```bash
kubectl create secret generic prometheus-additional-config \
-n monitoring \
--from-file=prometheus-additional-config.yaml=prometheus-additional-config-services.yaml
```

# 修改prometheus-prometheus.yaml
增加如下内容
```yaml
additionalScrapeConfigs:
  name: prometheus-additional-config
  key: prometheus-additional-config.yaml
```

重新 apply：
```bash
kubectl apply -f prometheus-prometheus.yaml
```

# 修改 clusterRole
修改后的 clusterRole 为：prometheus-clusterRole.yaml
```bash
kubectl apply -f prometheus-clusterRole.yaml
```
