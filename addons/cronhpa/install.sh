# install crd
kubectl apply -f crd/autoscaling_v1beta1_cronhorizontalpodautoscaler.yaml

# create ClusterRole
kubectl apply -f rbac/rbac_role.yaml

# create ClusterRolebinding and ServiceAccount
kubectl apply -f rbac/rbac_role_binding.yaml

# 部署控制器
kubectl apply -f deploy/deploy.yaml
