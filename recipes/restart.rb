bash "playframework restart" do
  user "root"
  code <<-EOH
  /etc/init.d/#{node[:play_app][:application_name]} restart
  EOH
end
