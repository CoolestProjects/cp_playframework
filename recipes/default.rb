#
# Author:: Sameer Arora (<sameera@bluepi.in>)
# Cookbook Name:: deploy-play
# Recipe:: default
#
# Copyright 2014, sameer11sep
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'zip'
include_recipe 'cp_baseconfiguration'
include_recipe "simple_iptables::redhat"

play_installation_dir="#{node[:play_app][:install_dir]}"
appName="#{node[:play_app][:application_name]}"
dist_url="#{node[:play_app][:dist_url]}"
app_version="#{node[:play_app][:app_version]}"
play_app_dir="#{play_installation_dir}/#{node[:play_app][:app_dir]}-#{app_version}"
config_dir="#{play_installation_dir}/#{node[:play_app][:config_dir]}"
http_port="#{node[:play_app][:port]}"
use_local_file="#{node[:play_app][:use_local_dist]}"
dist_local_file_path="#{node[:play_app][:dist_local_file_path]}"

directory "#{play_installation_dir}" do
  recursive true
  owner "root"
  group "root"
  mode 00644
  action :create
end

directory "/var/log/#{appName}" do
  recursive true
  owner "root"
  group "root"
  mode 00644
  action :create
end

#Download the Distribution Artifact from remote location Or use local file
if use_local_file == "true" 
	file "#{play_installation_dir}/#{appName}.zip" do
	  owner 'root'
	  group 'root'
	  mode 0644
	  content  ::File.open("#{dist_local_file_path}").read 
	  action :create
	end	
	
else
	bash "deploy war" do
		user node['root']
		group node['root']
		code <<-EOH
		curl -o #{play_installation_dir}/#{appName}.zip --user #{node['cp_baseconfiguration']['artifactory']['username']}:#{node['cp_baseconfiguration']['artifactory']['password']} #{dist_url}
  	chmod 644 #{play_installation_dir}/#{appName}.zip
	EOH
	end
end
	
directory "#{config_dir}" do
  recursive true
  owner "root"
  group "root"
  mode 00644
  action :create
end

#Unzip the Artifact and copy to the destination , assign permissions to the start script
bash "unzip-#{appName}" do
  cwd "/#{play_installation_dir}"
  code <<-EOH
     rm -rf #{play_app_dir}
     unzip #{play_installation_dir}/#{appName}.zip
     chmod +x #{play_app_dir}
  EOH
end

#Create the Application Conf file
#Add/remove variables here and in the application.conf.erb file as per your requirements e.g Database settings 
template "#{config_dir}/application.conf" do
  source "application.conf.erb"
  variables({
                :defaultConf => "#{play_app_dir}/conf/application.conf",
                :applicationSecretKey => "#{node[:play_app][:application_secret_key]}",
                :applicationLanguage => "#{node[:play_app][:language]}"
            })
end

#Define a logger file, change parameter values in attributes/default.rb as per your requirements
template "#{config_dir}/logger.xml" do
  source "logger.xml.erb"
  mode "0755"
  variables({
                :configDir => "#{config_dir}",
                :appName => "#{appName}",
                :maxHistory => "#{node[:play_app][:max_logging_history]}",
                :playLogLevel => "#{node[:play_app][:play_log_level]}",
                :logDir => "#{node[:play_app][:play_log_dir]}/#{appName}",
                :applicationLogLevel => "#{node[:play_app][:app_log_level]}"
            })
end

#Finally Define a Service for your Application to be kept under /etc/init.d 
template "/etc/init.d/#{appName}" do
  source "initd.erb"
  owner "root"
  group "root"
  mode "0744"
  variables({
                :name => "#{appName}",
                :path => "#{play_app_dir}/bin",
                :pidFilePath => "#{node[:play_app][:pid_file_path]}",
                :options => "-Dhttp.port=#{http_port} -Dconfig.file=#{config_dir}/application.conf -Dpidfile.path=#{node[:play_app][:pid_file_path]} -Dlogger.file=#{config_dir}/logger.xml #{node[:play_app][:vm_options]}",
                :command => "#{appName}"
            })
end

bash 'start server' do
  code <<-EOH
   /etc/init.d/#{appName} stop
   /etc/init.d/#{appName} start
    EOH
end

# Allow SSH
simple_iptables_rule "ssh" do
  rule "--proto tcp --dport 22"
  jump "ACCEPT"
end


simple_iptables_rule "http" do
  rule "--proto tcp --dport #{node[:play_app][:port]}"
  jump "ACCEPT"
end

service "iptables" do
  action :restart
end



