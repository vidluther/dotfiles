## Put this in your ~/.vagrant.d/ folder
## To enable/install the vagrant cachier plugin execute
## vagrant plugin install vagrant-cachier


Vagrant.configure("2") do |c|
	
	## This will speed up future provisioning of machines
	## considerably, after the first run.
	## To see what's cached, look in ~/.vagrant.d/cache/boxname..

	if Vagrant.has_plugin?("vagrant-cachier")
	    c.cache.scope = :box
	end
end

