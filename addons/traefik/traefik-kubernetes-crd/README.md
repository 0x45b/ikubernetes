# 使用说明

使用前需要修改 `traefik-ingress-ds.yaml` 文件，根据需要设置 `nodeSelector` 和 `tolerations`。

# 全局启用https重定向

如果需要全局将http请求重定向到https，需要在 `traefik-kubernetes-crd-ds.yaml` 中，取消如下注释：
```yaml
- --entrypoints.http.http.redirections.entryPoint.to=https
- --entrypoints.http.http.redirections.entryPoint.scheme=https
```