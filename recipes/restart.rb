appName="#{node[:play_app][:app_dir]}"
puts 'app dir #{appName}'

bash "playframework restart" do
  user "root"
  code <<-EOH
  /etc/init.d/#{appName} restart
  EOH
end
