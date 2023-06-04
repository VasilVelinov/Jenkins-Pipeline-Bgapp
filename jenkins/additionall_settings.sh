#!/bin/bash
echo "192.168.56.201 pipelines.do1.exam pipelines" >> /etc/hosts
echo "192.168.56.202 containers.do1.exam containers" >> /etc/hosts
echo "192.168.56.203 monitoring.do1.exam monitoring" >> /etc/hosts

echo "* Install Java, and git..."
dnf install -y java-17-openjdk
dnf install -y git

echo "*Install and prepare Node-exporter"
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz 
tar xzvf node_exporter-1.5.0.linux-amd64.tar.gz 
cd node_exporter-1.5.0.linux-amd64/
./node_exporter &> /tmp/node-exporter.log &

echo "* Enable firewall..."
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload

echo "* Setup SELinux..."
dnf install -y selinux-policy-devel setroubleshoot-server
sepolicy network -t http_port_t
semanage port -a -t http_port_t -p tcp 8080
sepolicy network -t http_port_t