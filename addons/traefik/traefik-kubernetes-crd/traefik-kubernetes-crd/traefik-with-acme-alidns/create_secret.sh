kubectl create secret -n traefik-ingress generic alicloud-dns \
    --from-literal=dns-key=<YOUR-ALICLOUD-KEY> \
    --from-literal=dns-secret=<YOUR-ALICLOUD-SECRET>