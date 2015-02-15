bash "playframework restart" do
  user "root"
  code <<-EOH
  /etc/init.d/#{node[:play_app][:app_dir]} restart
  EOH
end
