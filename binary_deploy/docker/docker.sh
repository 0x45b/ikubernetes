#!/bin/bash

# 安装依赖
yum install -y yum-utils lvm2 device-mapper-persistent-data bash-completion

# docker repo
cat > /etc/yum.repos.d/docker-ce.repo << "EOF"
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF

# 安装 docker
yum install -y docker-ce docker-ce-cli containerd.io

# docker daemon.json
mkdir /etc/docker
cat > /etc/docker/daemon.json << "EOF"
{
    "registry-mirrors": [
        "http://f1361db2.m.daocloud.io",
        "https://reg-mirror.qiniu.com"
    ]
}
EOF

# 启动 docker
systemctl enable docker
systemctl restart docker
