# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.berkshelf.enabled = true
  config.vm.hostname = "cp-playframework"

  config.vm.synced_folder "./sql", "/vagrant_data"

  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_centos-6.4_chef-11.4.4.box"
  config.vm.box = "platform-centos"
  config.vm.network :forwarded_port, guest: 3306, host: 3306  # MySQL
  config.vm.network :forwarded_port, guest: 9000, host: 9000  # Play Framework

  config.vm.provision :chef_solo do |chef|
    
    chef.log_level = :debug
    chef.json = {
      :play_app => {
        :install_dir => '/opt/coolestprojects',
        :dist_url => '',
        :port => '9000',
        :application_name => 'userservice',
        :vm_options => '-J-Xms512M -J-Xmx1024M -J-Xss1M -J-XX:MaxPermSize=512M',
        :override_config => {
          "db.default.driver" => '"com.mysql.jdbc.Driver"',
          "db.default.url" => '"jdbc:mysql://localhost:3306/userservice"',
          "db.default.user" => '"root"',
          "db.default.password" => '"cpmysql123"',
          "db.default.logStatements" => true,
          "applyEvolutions.default" => true,
          "db.default.logStatements"=>true,
          "app_dir" => '"userservice-1.0-SNAPSHOT"'
        }
      }
    }
    chef.add_recipe "cp_java::default"
    chef.add_recipe "cp_playframework::default"
  end
end
