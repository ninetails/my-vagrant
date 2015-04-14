# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

VAGRANTFILE_API_VERSION = "2"

vconfig = YAML::load_file('./config.yaml')

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Vagrant Plugin: vagrant-cachier
  if vconfig['plugins']['cachier']
    config.cache.auto_detect = true
  end

  # Virtualbox config
  if vconfig.has_key?('virtualbox') && vconfig['virtualbox'].has_key?('customize') && (vconfig['virtualbox']['customize'].respond_to? :each)
    config.vm.provider "virtualbox" do |v|
      vconfig['virtualbox']['customize'].each do |key, value|
        v.customize ["modifyvm", :id, "--#{key}", value]
      end
    end
  end

  if vconfig.has_key?('machines') && (vconfig['machines'].respond_to? :each)
    vconfig['machines'].each do |name, vmconf|
      config.vm.define name do |machine|

        if vmconf.has_key?('vm')
          machine.vm.box = vmconf['vm']['box']
          machine.vm.box_url = vmconf['vm']['box_url']

          machine.vm.hostname = vmconf['vm']['hostname']

          # Vagrant Plugin: vagrant-hostsupdater
          if vmconf['vm'].has_key?('hostsupdater')
            if vmconf['vm']['hostsupdater'].has_key?('aliases')
              machine.hostsupdater.aliases = vmconf['vm']['hostsupdater']['aliases']
            end
          end

          if vmconf['vm'].has_key?('private_network')
            machine.vm.network :private_network, ip: vmconf['vm']['private_network']['ip']
          end

          if vmconf['vm'].has_key?('forwarded_port') && (vmconf['vm']['forwarded_port'].respond_to? :each)
            vmconf['vm']['forwarded_port'].each do |ports|
              machine.vm.network :forwarded_port, guest: ports['guest'], host: ports['host']
            end
          end

          if vmconf['vm'].has_key?('synced_folder') && (vmconf['vm']['synced_folder'].respond_to? :each)
            vmconf['vm']['synced_folder'].each do |folder|
              machine.vm.synced_folder folder['host_directory'], folder['guest_directory'], id: folder['id'], nfs: folder.has_key?('nfs') ? folder['nfs'] : false
            end
          end

        end # end vm

        if vmconf.has_key?('puppet') && (vmconf['puppet'].respond_to? :each)
          # updates puppet before puppet provisions
          machine.vm.provision :shell, :path => "./shell/upgrade-puppet.sh"

          vmconf['puppet'].each do |provision|
            machine.vm.provision :puppet do |puppet|
              provision.each do |key, value|
                puppet.send("#{key}=", value)
              end
            end
          end

        end #end puppet :each

      end # end each machine
    end
  end # end machines

end