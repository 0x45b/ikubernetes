# get token
kubectl get secret -n kubernetes-dashboard $(kubectl -n kubernetes-dashboard get secret | grep kubernetes-dashboard-token | awk '{print $1}') -o go-template='{{.data.token}}' | base64 -d

echo
