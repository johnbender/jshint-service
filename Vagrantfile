Vagrant::Config.run do |config|
  config.vm.box = "base"
  config.vm.network("33.33.33.10")
  config.vm.customize do |vm|
    vm.name = "jshint service"
    vm.memory_size = 512
  end

  # Share the WWW folder as the main folder for the web VM using NFS
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  # Configure to provision with local cookbooks
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["cookbooks"]
    chef.add_recipe "jshint-service"
  end
end
