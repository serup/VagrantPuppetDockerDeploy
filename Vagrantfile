# vi: set ft=ruby :

# puppet setup. Starts a puppet master with modules mapped in, and a client
# to tests
 
nodes_config = (JSON.parse(File.read("nodes.json")))['nodes']
puppet_source = ENV['DOCKER_PUPPET_PATH']
puts puppet_source
if puppet_source == nil
#   puts "NodeOS: " + nodeOS
   puts "Please run install.sh script as . ./install.sh or set DOCKER_PUPPET_PATH to your checkout of devtest, test and production"
   exit
end

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  nodes_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node

	if node_name == "puppet.docker.local"
		config.vm.define "puppet.docker.local", primary: true
	else
		config.vm.define node_name.to_s, autostart: false
	end	

    config.vm.define node_name do |config|   
      # Enable provisioning with Puppet stand alone.
      config.vm.provision :puppet do |puppet|
	puppet.manifests_path = "puppet/manifests"
	puppet.manifest_file  = "site.pp"
	puppet.module_path = "puppet/trunk/environments/devtest/modules"
	puppet.options = "--verbose --debug"
      end 

      # configures all forwarding ports in JSON array
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
          host:  port[':host'],
          guest: port[':guest'],
          id:    port[':id']
      end

      if node_name == "puppet.docker.local"
        config.vm.synced_folder puppet_source, '/etc/puppet/environments'
      end


      config.vm.provision :shell, :path => node_values['bootstrap']
      config.vm.box = node_values['nodeOS']
      config.vm.hostname = node_values[':hostname']
      config.vm.network :private_network, ip: node_values[':ip']

      config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", node_values[':memory']]
        vb.customize ["modifyvm", :id, "--name", node_name]
        vb.customize ["modifyvm", :id, "--vram", "16"]
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
	    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      end
    end
  end
end
