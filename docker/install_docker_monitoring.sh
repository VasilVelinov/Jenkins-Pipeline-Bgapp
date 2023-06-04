echo "* Add the Docker repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "* Install the packages (Java, git, Docker)"
dnf install -y docker-ce docker-ce-cli containerd.io

echo "* Change Docker configuration to expose Docker metrics"
cp /vagrant/daemon.json /etc/docker/
sleep 1m

echo "* Start the Docker service"
systemctl enable --now docker

echo "* Adjust the group membership"
usermod -aG docker vagrant

echo "* Adjust the firewall"
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=5000/tcp
firewall-cmd --permanent --add-port=9100/tcp
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload