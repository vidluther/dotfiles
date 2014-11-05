## Put this in your ~/.vagrant.d/ folder
## To enable/install the vagrant cachier plugin execute
## vagrant plugin install vagrant-cachier


Vagrant.configure("2") do |c|

	# If a local VM becomes in-accessible (firewall rule testing)
	# Re-create the machine, but set uncomment the vb.gui line.
	# Then you can use the vmware/virtualbox console. 
	c.vm.provider "virtualbox" do |vb|
        	#vb.gui = true
	end


	
	## This will speed up future provisioning of machines
	## considerably, after the first run.
	## To see what's cached, look in ~/.vagrant.d/cache/boxname..

	 if Vagrant.has_plugin?("vagrant-cachier")
    		c.cache.scope       = :machine # or :box
    		c.cache.auto_detect = false
  	end

end

