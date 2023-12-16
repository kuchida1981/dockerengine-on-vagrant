# -*- mode: ruby -*-
# vi: set ft=ruby :
hogehoge
docker_guest_port = "2376"
docker_guest_host = "tcp://0.0.0.0:#{docker_guest_port}"
docker_host_port = ENV["DOCKER_PORT"] || "12376"
shared_dir = ENV["VAGRANT_DOCKER_DIR"] || ENV["HOME"]

Vagrant.configure("2") do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.disk :disk, size: "120GB", primary: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 8192
    vb.cpus = 8
    vb.customize ["setextradata", :id, "VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled", 0]
  end

  config.vm.network "forwarded_port", guest: docker_guest_port, host: docker_host_port
  config.vm.network "private_network", type: "dhcp", name: "vboxnet1"

  config.vm.synced_folder shared_dir, shared_dir

  config.vm.provision "shell", inline: <<-SHELL
  resize2fs /dev/sda1
  echo DOCKER_HOST=#{docker_guest_host} >> /etc/environment
  export DOCKER_HOST=#{docker_guest_host}

  mkdir -p /etc/systemd/system/docker.service.d
  cat <<EOF > /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H #{docker_guest_host}
EOF

  apt-get update && apt-get install -y curl systemd-timesyncd
  curl -fsSL https://get.docker.com | sh
  adduser vagrant docker
  SHELL
end
