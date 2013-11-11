template "#{node[:postgresql][:data_directory]}/recovery.conf" do
  notifies :restart, "service[postgresql]"
end
