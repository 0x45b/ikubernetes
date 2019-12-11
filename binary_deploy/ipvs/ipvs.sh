#!/bin/bash

# 安装 ipvs
yum install -y ipvsadm ipset sysstat conntrack libseccomp

# 载入 ipvs 模块
cat > /etc/modules-load.d/ipvs.conf << "EOF"
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_lc
ip_vs_wlc
ip_vs_sh
nf_conntrack
br_netfilter
EOF

# 启用该模块
systemctl enable --now systemd-modules-load.service

# 设置ipvs hash table
cat > /etc/modprobe.d/ipvs.conf << "EOF"
options ip_vs conn_tab_bits=22
EOF

# 开机自启动 ipvsadm
systemctl enable ipvsadm --now
