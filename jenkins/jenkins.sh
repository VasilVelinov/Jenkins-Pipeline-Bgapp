#!/bin/bash

echo "* Install Jenkins..."
wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
dnf makecache
dnf install -y jenkins

echo "*Set up jenkins user"
usermod -s /bin/bash jenkins
echo -e "Password1\nPassword1" | passwd jenkins
echo "jenkins ALL=(ALL)    NOPASSWD: ALL" | (EDITOR="tee -a" visudo)


echo "Skipping the initial setup"
echo 'JAVA_ARGS="-Djenkins.install.runSetupWizard=false"' >> /etc/default/jenkins

echo "Setting up users"
rm -rf /var/lib/jenkins/init.groovy.d
mkdir /var/lib/jenkins/init.groovy.d
cp -v /vagrant/jenkins/01_globalMatrixAuthorizationStrategy.groovy /var/lib/jenkins/init.groovy.d/
cp -v /vagrant/jenkins/02_createAdminUser.groovy /var/lib/jenkins/init.groovy.d/

echo "* Enable Jenkins..."
systemctl enable --now jenkins
sleep 1m

echo "Installing jenkins plugins"
JENKINSPWD=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)
rm -f jenkins_cli.jar.*
wget -q http://192.168.56.201:8080/jnlpJars/jenkins-cli.jar
while IFS= read -r line
do
  list=$list' '$line
done < /vagrant/jenkins/jenkins_plugins.txt
java -jar ./jenkins-cli.jar -auth admin:$JENKINSPWD -s http://192.168.56.201:8080 install-plugin $list

echo "Restarting Jenkins"
systemctl restart jenkins
sleep 1m