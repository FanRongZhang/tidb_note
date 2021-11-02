#!/bin/bash

# 关闭防火墙
echo "=========stop firewalld============="
systemctl stop firewalld
systemctl disable firewalld
systemctl status firewalld

# 关闭NetworkManager
echo "=========stop NetworkManager ============="
systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl status NetworkManager

# 关闭selinux
echo "=========disable selinux============="
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
setenforce 0
getenforce

# 关闭swap
echo "=========close swap============="
sed -ri 's/.*swap.*/#&/' /etc/fstab
swapoff -a
free -m

# 时间同步
echo "=========sync time============="
yum install chrony -y
cat >> /etc/chrony.conf << EOF
server ntp.aliyun.com iburst
EOF
systemctl start chronyd
systemctl enable chronyd
chronyc sources

#配置yum
echo "=========config yum============="
yum install wget net-tools telnet tree nmap sysstat lrzsz dos2unix -y
wget -O /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo
wget -O /etc/yum.repos.d/epel.repo  http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all
yum makecache
