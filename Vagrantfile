Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.provision :shell, :path => "provision/setup.sh"
    config.vm.network :forwarded_port, host: 8545, guest: 8545
    config.ssh.insert_key = true
    config.vm.synced_folder "sh", "/home/vagrant/sh"
    config.vm.synced_folder "contracts", "/home/vagrant/contracts"
    config.vm.synced_folder "js", "/home/vagrant/js"

    config.vm.provider :virtualbox do |vb|
        vb.gui = true
        # Use VBoxManage to customize the VM. For example to change memory:
        vb.customize ["modifyvm", :id, "--name", "ethereum-lunchpay-ubuntu-trusty64-vm-virtualbox"]
        vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.customize ["modifyvm", :id, "--vram", 64]
        vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
        vb.customize ['modifyvm', :id, '--clipboard', 'bidirectional']
        vb.customize ['modifyvm', :id, '--draganddrop', 'bidirectional']
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
end
