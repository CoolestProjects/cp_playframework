bash "playframework start" do
  user "root"
  code <<-EOH
  /etc/init.d/#{node[:play_app][:app_name]} start
  EOH
end
