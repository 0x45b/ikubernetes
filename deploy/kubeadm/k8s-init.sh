# config ntp
yum install -y ntp

cat > /etc/ntp.conf << "EOF"
driftfile /var/lib/ntp/drift
logfile /var/log/ntp.log
pidfile /var/run/ntp.pid

restrict -6 default ignore
restrict    default ignore
restrict -6 ::1
restrict    127.0.0.1

restrict 10.0.100.0 mask 255.255.0.0 nomodify notrap noquery nopeer kod

server ntp.aliyun.com iburst minpoll 4 maxpoll 10
restrict ntp.aliyun.com nomodify notrap noquery nopeer

disable monitor
EOF

systemctl stop chronyd
systemctl disable chronyd

systemctl enable ntpd
systemctl start ntpd

# disable firewalld
systemctl stop firewalld
systemctl disable firewalld

# disable NetworkManager
systemctl disable NetworkManager
systemctl stop NetworkManager

# disable selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# config ulimit
cat > /etc/security/limits.d/99-nofile.conf << EOF
*   soft    nproc   65535
*   hard    nproc   65535
*   soft    nofile  819200
*   hard    nofile  819200
EOF

# config ipvs
yum install -y ipvsadm ipset sysstat conntrack libseccomp

cat > /etc/modules-load.d/ipvs.conf <<EOF
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_lc
ip_vs_wlc
ip_vs_sh
nf_conntrack
br_netfilter
EOF

systemctl enable systemd-modules-load.service

# config ipvs hash table
cat > /etc/modprobe.d/ipvs.conf << EOF
options ip_vs conn_tab_bits=22
EOF

systemctl enable ipvsadm

# set kernel parameters
cat > /etc/sysctl.d/k8s.conf <<EOF
# https://github.com/moby/moby/issues/31208 
# ipvsadm -l --timout
# 修复ipvs模式下长连接timeout问题 小于900即可
net.ipv4.tcp_keepalive_time = 600
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 10
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv4.neigh.default.gc_stale_time = 120
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2
net.ipv4.ip_forward = 1
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 262140
net.ipv4.tcp_synack_retries = 2
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-arptables = 1
net.netfilter.nf_conntrack_max = 2310720
net.core.somaxconn = 65535
net.ipv4.tcp_tw_recycle = 0
fs.inotify.max_user_watches=1048576
fs.inotify.max_user_instances=8192
fs.may_detach_mounts = 1
fs.file-max = 52706963
fs.nr_open = 52706963
vm.swappiness = 0
vm.overcommit_memory = 1
vm.panic_on_oom = 0
EOF

sysctl --system

# config docker yum repo
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# install docker
yum install -y yum-utils device-mapper-persistent-data lvm2
yum install -y docker-ce docker-ce-cli containerd.io
mkdir /etc/docker
cat > /etc/docker/daemon.json << 'EOF'
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "registry-mirrors": [
        "http://f1361db2.m.daocloud.io",
        "https://reg-mirror.qiniu.com"
    ],
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "storage-opts": [
      "overlay2.override_kernel_check=true"
    ]
}
EOF
systemctl enable docker

# kubernetes yum repo
cat > /etc/yum.repos.d/kubernetes.repo << "EOF"
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubelet-1.16.4 kubeadm-1.16.4 kubectl-1.16.4
systemctl enable kubelet

