#!/bin/bash

echo "192.168.56.201 pipelines.do1.exam pipelines" >> /etc/hosts
echo "192.168.56.202 containers.do1.exam containers" >> /etc/hosts
echo "192.168.56.203 monitoring.do1.exam monitoring" >> /etc/hosts

echo "* Set up jenkins user"
useradd jenkins
usermod -s /bin/bash jenkins
echo -e "Password1\nPassword1" | passwd jenkins
echo "jenkins ALL=(ALL)    NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
echo "* Adjust the group membership"
usermod -aG docker jenkins

echo "*Install and prepare Node-exporter"
wget https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz 
tar xzvf node_exporter-1.5.0.linux-amd64.tar.gz 
cd node_exporter-1.5.0.linux-amd64/
./node_exporter &> /tmp/node-exporter.log &