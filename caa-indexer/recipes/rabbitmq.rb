include_recipe "rabbitmq"

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
