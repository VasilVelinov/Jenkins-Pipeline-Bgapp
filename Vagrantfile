# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
    
  config.ssh.insert_key = false

  config.vm.define "pipelines" do |pipelines|
    pipelines.vm.box="shekeriev/centos-stream-9"
    pipelines.vm.hostname = "pipelines.do1.exam"
    pipelines.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end
    pipelines.vm.network "private_network", ip: "192.168.56.201"
    pipelines.vm.network "forwarded_port", guest: 8080, host: 8080
    pipelines.vm.provision "shell", path: "jenkins/additionall_settings.sh"
    pipelines.vm.provision "shell", path: "jenkins/jenkins.sh"
    
  end
  
  config.vm.define "containers" do |containers|
    containers.vm.box = "shekeriev/centos-stream-9"
    containers.vm.hostname = "containers.do1.exam"
    containers.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end
    containers.vm.network "private_network", ip: "192.168.56.202"
	  containers.vm.provision "shell", path: "docker/install_docker.sh"
    containers.vm.provision "shell", path: "docker/additionall_settings.sh"
    containers.vm.provision "shell", path: "docker/run_gitea_docker.sh"
  end
  
  config.vm.define "monitoring" do |monitoring|
    monitoring.vm.box="shekeriev/centos-stream-9"
    monitoring.vm.hostname = "monitoring.do1.exam"
    monitoring.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "4096"]
    end
    monitoring.vm.network "private_network", ip: "192.168.56.203"
    monitoring.vm.provision "shell", path: "docker/install_docker_monitoring.sh"
    monitoring.vm.provision "shell", path: "docker/run_containers.sh"
    monitoring.vm.synced_folder "vagrant/", "/vagrant"
  end

  
end
