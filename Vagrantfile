# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.network "public_network"

  config.vm.synced_folder Dir.pwd, Dir.pwd

  config.vm.provision "shell", inline: <<-SHELL
  curl -fsSL https://get.docker.com | sh
  sudo curl -L \
    https://github.com/docker/compose/releases/download/v2.4.1/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  sudo adduser vagrant docker
  SHELL
end
