#!/bin/bash

function kube-controller-manager() {
    # 1. 设置集群参数
    kubectl config set-cluster kubernetes \
        --certificate-authority=$CERTS/ca/ca.pem \
        --embed-certs=true \
        --server=$KUBE_APISERVER \
        --kubeconfig=kube-controller-manager.kubeconfig
        
    # 2. 设置客户端认证参数
    kubectl config set-credentials system:kube-controller-manager \
        --embed-certs=true \
        --client-certificate=$CERTS/kube-controller-manager/kube-controller-manager.pem \
        --client-key=$CERTS/kube-controller-manager/kube-controller-manager-key.pem \
        --kubeconfig=kube-controller-manager.kubeconfig

    # 3. 设置上下文参数
    kubectl config set-context system:kube-controller-manager \
        --cluster=kubernetes \
        --user=system:kube-controller-manager \
        --kubeconfig=kube-controller-manager.kubeconfig
        
    # 4. 设置当前所使用的上下文
    kubectl config use-context system:kube-controller-manager \
        --kubeconfig=kube-controller-manager.kubeconfig
}

function kube-scheduler() {
    # 设置集群参数
    kubectl config set-cluster kubernetes \
        --certificate-authority=$CERTS/ca/ca.pem \
        --embed-certs=true \
        --server=$KUBE_APISERVER \
        --kubeconfig=kube-scheduler.kubeconfig

    # 设置客户端认证参数
    kubectl config set-credentials system:kube-scheduler \
        --client-certificate=$CERTS/kube-scheduler/kube-scheduler.pem \
        --client-key=$CERTS/kube-scheduler/kube-scheduler-key.pem \
        --embed-certs=true \
        --kubeconfig=kube-scheduler.kubeconfig

    # 设置上下文参数
    kubectl config set-context system:kube-scheduler \
        --cluster=kubernetes \
        --user=system:kube-scheduler \
        --kubeconfig=kube-scheduler.kubeconfig

    # 设置当前使用的上下文
    kubectl config use-context system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig
}

function kube-proxy() {
    # 设置集群参数
    kubectl config set-cluster kubernetes \
        --certificate-authority=$CERTS/ca/ca.pem \
        --embed-certs=true \
        --server=$KUBE_APISERVER \
        --kubeconfig=kube-proxy.kubeconfig

    # 设置客户端认证参数
    kubectl config set-credentials system:kube-proxy \
    --client-certificate=$CERTS/kube-proxy/kube-proxy.pem \
    --client-key=$CERTS/kube-proxy/kube-proxy-key.pem \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

    # 设置上下文参数
    kubectl config set-context system:kube-proxy \
    --cluster=kubernetes \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

    # 设置当前使用的上下文
    kubectl config use-context system:kube-proxy --kubeconfig=kube-proxy.kubeconfig
}

function kubelet-bootstrap() {
    # 产生一个永久 token
    TOKEN_PUB=$(openssl rand -hex 3)
    TOKEN_SECRET=$(openssl rand -hex 8)
    BOOTSTRAP_TOKEN="${TOKEN_PUB}.${TOKEN_SECRET}"

    kubectl -n kube-system create secret generic bootstrap-token-${TOKEN_PUB} \
        --type 'bootstrap.kubernetes.io/token' \
        --from-literal description="kubelet-bootstrap-token" \
        --from-literal token-id=${TOKEN_PUB} \
        --from-literal token-secret=${TOKEN_SECRET} \
        --from-literal usage-bootstrap-authentication=true \
        --from-literal usage-bootstrap-signing=true

    # 创建 kubelet-bootstrap kubeconfig
    # 设置集群参数
    kubectl config set-cluster kubernetes \
        --certificate-authority=$CERTS/ca/ca.pem \
        --server=$KUBE_APISERVER \
        --embed-certs=true \
        --kubeconfig=kubelet-bootstrap.kubeconfig
        
    # 设置客户端认证参数
    kubectl config set-credentials kubelet-bootstrap \
        --token=$BOOTSTRAP_TOKEN \
        --kubeconfig=kubelet-bootstrap.kubeconfig
        
    # 设置上下文参数
    kubectl config set-context kubelet-bootstrap  \
        --cluster=kubernetes \
        --user=kubelet-bootstrap \
        --kubeconfig=kubelet-bootstrap.kubeconfig

    # 设置默认上下文
    kubectl config use-context kubelet-bootstrap --kubeconfig=kubelet-bootstrap.kubeconfig
}

function kubernetes-admin() {
    # 1. 设置集群参数
    kubectl config set-cluster kubernetes \
        --certificate-authority=$CERTS/certs/ca/ca.pem \
        --embed-certs=true \
        --server=$KUBE_APISERVER \
        --kubeconfig=kubernetes-admin.kubeconfig

    # 2. 设置客户端认证参数
    kubectl config set-credentials kubernetes-admin \
        --client-certificate=$CERTS/kubernetes-admin/kubernetes-admin.pem \
        --client-key=$CERTS/kubernetes-admin/kubernetes-admin-key.pem \
        --embed-certs=true \
        --kubeconfig=kubernetes-admin.kubeconfig

    # 3. 设置上下文参数
    kubectl config set-context kubernetes-admin \
        --cluster=kubernetes \
        --user=kubernetes-admin \
        --kubeconfig=kubernetes-admin.kubeconfig

    # 4. 设置当前使用的上下文
    kubectl config use-context kubernetes-admin --kubeconfig=kubernetes-admin.kubeconfig
}

function help() {
    echo
    echo "$0 kube-controller-manager KUBE-APISERVER-ADDRESS   :产生kube-controller-manager 的 kubeconfig 文件"
    echo "$0 kube-scheduler KUBE-APISERVER-ADDRESS            :产生kube-scheduler 的 kubeconfig 文件"
    echo "$0 kube-proxy KUBE-APISERVER-ADDRESS                :产生kube-proxy 的 kubeconfig 文件"
    echo "$0 kubelet-bootstrap KUBE-APISERVER-ADDRESS         :产生kubelet-bootstrap 的 kubeconfig 文件"
    echo "$0 kubernetes-admin KUBE-APISERVER-ADDRESS          :产生kubernetes-admin 的 kubeconfig 文件"
    echo "$0 all KUBE-APISERVER-ADDRESS                       :产生以上所有的 kubeconfig 文件"
    echo "$0 clear                                            :删除以上所有的 kubeconfig 文件"
    exit 0
}

if [ "$1" == "clear" ]; then
    rm -rf kube-controller-manager.kubeconfig
    rm -rf kube-scheduler.kubeconfig
    rm -rf kube-proxy.kubeconfig
    rm -rf kubelet-bootstrap.kubeconfig
    rm -rf kubernetes-admin.kubeconfig
elif [ $# -ne 2 ]; then
    help
else
    CERTS="$(dirname $(pwd))/certs"
    KUBE_APISERVER=$2
    case $1 in
        "kube-controller-manager")
            kube-controller-manager
            ;;
        "kube-scheduler")
            kube-scheduler
            ;;
        "kube-proxy")
            kube-proxy
            ;;
        "kubelet-bootstrap")
            kubelet-bootstrap
            ;;
        "kubernetes-admin")
            kubernetes-admin
            ;;
        "all")
            kube-controller-manager
            kube-scheduler
            kube-proxy
            kubelet-bootstrap
            kubernetes-admin
            ;;
        *)
          help
    esac
fi
