include_recipe "daemontools"
include_recipe "rabbitmq"

daemontools_service "caa-indexer" do
  directory "/home/caaindexer/CAA-indexer/svc"
  template false
  action [:enable,:start]
end

template "/home/caaindexer/CAA-indexer/config.ini" do
  owner "caaindexer"
  mode "644"
  variables node['caa-indexer']
end

link "/home/caaindexer/CAA-indexer/svc/CAA-indexer" do
  to "/home/caaindexer/CAA-indexer"
end

rabbitmq_vhost node['caa-indexer']['rabbitmq']['vhost'] do
  action :add
end

rabbitmq_user node['caa-indexer']['rabbitmq']['user'] do
  password node['caa-indexer']['rabbitmq']['password']
  action :add
end

rabbitmq_user node['caa-indexer']['rabbitmq']['user'] do
  vhost node['caa-indexer']['rabbitmq']['vhost']
  permissions ".* .* .*"
  action :set_permissions
end
