#!/bin/bash

function ca() {
	mkdir ca
	cfssl gencert -initca=true ca-csr.json | cfssljson -bare ca/ca
}

function etcd() {
	mkdir etcd
    cfssl gencert \
    	-ca ca/ca.pem \
    	-ca-key ca/ca-key.pem \
    	-config config.json \
    	-profile k8s etcd-csr.json | cfssljson -bare etcd/etcd
}

function flannel() {
	mkdir flannel
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s flannel-csr.json | cfssljson -bare flannel/flannel
}

function admin() {
	mkdir kubernetes-admin
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s kubernetes-admin-csr.json | cfssljson -bare kubernetes-admin/kubernetes-admin
}

function kube-apiserver() {
	mkdir kube-apiserver
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s kube-apiserver-csr.json | cfssljson -bare kube-apiserver/kube-apiserver
}

function sa() {
	mkdir kube-apiserver
    openssl genrsa -out kube-apiserver/service-account.key 2048
	openssl rsa -in kube-apiserver/service-account.key -pubout -outform pem -out kube-apiserver/service-account.pub
}

function apiserver-kubelet() {
	mkdir kube-apiserver
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s apiserver-kubelet-client-csr.json | cfssljson -bare kube-apiserver/apiserver-kubelet-client
}

function proxy-client() {
	mkdir kube-apiserver
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s proxy-client-csr.json | cfssljson -bare kube-apiserver/proxy-client
}

function kube-controller-manager() {
	mkdir kube-controller-manager
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager/kube-controller-manager
}

function kube-scheduler() {
	mkdir kube-scheduler
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s kube-scheduler-csr.json | cfssljson -bare kube-scheduler/kube-scheduler
}

function kube-proxy() {
	mkdir kube-proxy
	cfssl gencert \
 	   -ca ca/ca.pem \
 	   -ca-key ca/ca-key.pem \
 	   -config config.json \
 	   -profile k8s kube-proxy-csr.json | cfssljson -bare kube-proxy/kube-proxy
}

case $1 in
	"ca")
		ca
		;;
	"sa")
		sa
		;;
	"etcd")
		etcd
		;;
	"flannel")
		flannel
		;;
	"admin")
		admin
		;;
	"kube-apiserver")
		kube-apiserver
		;;
	"apiserver-kubelet")
		apiserver-kubelet
		;;
	"proxy-client")
		proxy-client
		;;
	"kube-controller-manager")
		kube-controller-manager
		;;
	"kube-schedule")
		kube-schedule
		;;
	"kube-proxy")
		kube-proxy
		;;
	"all")
		ca
		sa
		etcd
		flannel
		admin
		kube-apiserver
		apiserver-kubelet
		proxy-client
		kube-controller-manager
		kube-scheduler
		kube-proxy
		;;
	"clear")
		rm -rf ca kube-apiserver kube-controller-manager kube-scheduler kube-proxy etcd flannel kubernetes-admin
		;;
	"*")
		echo "Usage: $0 {ca|sa|all|kube-apiserver|apiserver-kubelet|proxy-client|admin|kube-controller-manager|kube-proxy|etcd|flannel|admin|clear}"
esac
