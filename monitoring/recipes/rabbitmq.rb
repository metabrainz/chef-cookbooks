include_recipe "cabal"

user "monitoring" do
  action :create
  home "/home/monitoring"
  shell "/bin/bash"
  supports :manage_home => true
end

package "cabal-install"
cabal_install "gamekeeper" do
  github "brendanhay/gamekeeper"
  user "monitoring"
  cabal_update true
  install_binary :from => 'dist/build/gamekeeper/gamekeeper', :to => '/usr/bin/gamekeeper'
  force_reinstalls true
end

rabbitmq_user node['monitoring']['rabbitmq']['user'] do
  action :add
  password node['monitoring']['rabbitmq']['password']
end

rabbitmq_user node['monitoring']['rabbitmq']['user'] do
  vhost node['caa-indexer']['rabbitmq']['vhost']
  action :set_permissions
  permissions "'' '' .*"
end

cron "rabbitmq" do
  mailto "root"
  user "monitoring"
  command "gamekeeper measure --uri=http://#{node['monitoring']['rabbitmq']['user']}:#{node['monitoring']['rabbitmq']['password']}@#{node['monitoring']['rabbitmq']['host']}:#{node['monitoring']['rabbitmq']['port']}/ --sink=Graphite,#{node['monitoring']['graphite']['host']},#{node['monitoring']['graphite']['port']}"
end
