user "musicbrainz" do
  action :create
  home "/home/musicbrainz"
  shell "/bin/bash"
  supports :manage_home => true
end

package "haskell-platform"
package "libpq-dev"

cabal_update "musicbrainz"

cabal_install "musicbrainz-email" do
  github "metabrainz/musicbrainz-email"
  user "musicbrainz"
  reference "initial"
end

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

rabbitmq_vhost "/email" do
  action :add
end

rabbitmq_user "musicbrainz" do
  password "musicbrainz"
  vhost "/email"
  permissions ".* .* .*"
  action :add
end

rabbitmq_plugin "rabbitmq_management" do
  action :enable
end

daemontools_service "musicbrainz-email" do
  template "musicbrainz-email"
  action [:enable,:restart]
  directory "/home/musicbrainz/musicbrainz-email"
end

package "sendmail" do
  action :install
end

service "sendmail" do
  action [:enable, :start]
end
