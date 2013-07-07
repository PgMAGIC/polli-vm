# -*- mode: ruby -*-
# vi: set ft=ruby :

hostIP = "192.168.100.40"

Vagrant::configure('2') do |config|
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end


Vagrant::Config.run do |config|

  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.boot_mode = :headless
  config.vm.network :hostonly, "192.168.33.11"
  config.vm.forward_port 8081,8081
  config.vm.share_folder "templates", "/tmp/vagrant-puppet/templates", "./puppet/templates"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.options = ["--templatedir","/tmp/vagrant-puppet/templates"]
    puppet.manifest_file  = "base.pp"

    puppet.facter["theserverip"] = hostIP
  end
end
