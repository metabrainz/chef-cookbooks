user "monitoring"

include_recipe "apt"
apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "D58E52C99814760488A38D87E3446F96A3FB3557"
end

package "gamekeeper"

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
