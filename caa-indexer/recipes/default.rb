include_recipe "daemontools"
include_recipe "rabbitmq"

user "caaindexer" do
  action :create
  home "/home/caaindexer"
  shell "/bin/bash"
  supports :manage_home => true
end

package "git"
git "/home/caaindexer/CAA-indexer" do
  repository "git://github.com/metabrainz/CAA-indexer.git"
  revision "rabbitmq"
  action :sync
  user "caa"
end

daemontools_service "caa-indexer" do
  directory "/home/caaindexer/CAA-indexer/svc"
  template false
  action [:enable,:start]
end

package "libanyevent-perl"
package "libconfig-tiny-perl"
package "libdbd-pg-perl"
package "libdbix-simple-perl"
package "libjson-any-perl"
package "liblog-contextual-perl"
package "libnet-amazon-s3-perl"
package "libtry-tiny-perl"
package "libwww-perl"
package "libxml-xpath-perl"

package "libnet-rabbitfoot-perl"

template "/home/caaindexer/CAA-indexer/config.ini" do
  owner "caaindexer"
  mode "644"
  variables node['caa-indexer']
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
