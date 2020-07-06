# prometheus-operator 目录说明

* ingress
    官方提供的组件默认没有提供相应的 ingress 配置，需要用 NodePort 的方式访问 prometheus、alertmanger 以及 grafana。

    在 patch/ingress 目录下，提供了这三个组件的 ingress 配置，在使用时，需要修改下 host。

* kube-scheduler 和 kube-controller-manager target 为0的问题
    默认情况下，kube-scheduler 和 kube-controller-manager 使用 k8s-app: kube-scheduler 和 k8s-app: kube-controller-manager 匹配 service。

    如果使用二进制部署的话，是没有这两个service 的，因此显示的 target 为0.

    在 patch/kube-scheduler 和 path/kube-controller-manager 中，提供了相应的配置，在使用时，需要修改相应的 ep 文件，修改成你自己的 endpoint 的地址和端口。


