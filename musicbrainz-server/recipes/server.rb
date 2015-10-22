include_recipe "daemontools"
include_recipe "musicbrainz-server::install"
include_recipe "nginx"

package "libcatalyst-plugin-autorestart-perl"
package "libcatalyst-plugin-errorcatcher-perl"
package "libstarlet-perl"

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "musicbrainz-server-renderer" do
  directory "/home/musicbrainz/svc-musicbrainz-server-renderer"
  template "musicbrainz-server-renderer"
  variables :port => node['musicbrainz-server']['renderer-port']
  action [:enable, :start]
  subscribes :restart, "git[/home/musicbrainz/musicbrainz-server]"
  log false
end

daemontools_service "musicbrainz-server" do
  directory "/home/musicbrainz/svc-musicbrainz-server"
  template "musicbrainz-server"
  variables :nproc => node['musicbrainz-server']['nproc-website']
  action [:enable,:start]
  subscribes :restart, "git[/home/musicbrainz/musicbrainz-server]"
  subscribes :restart, "template[/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm]"
  log true
end

daemontools_service "musicbrainz-ws" do
  directory "/home/musicbrainz/svc-musicbrainz-ws"
  template "musicbrainz-ws"
  variables :nproc => node['musicbrainz-server']['nproc-ws']
  action [:enable,:start]
  subscribes :restart, "git[/home/musicbrainz/musicbrainz-server]"
  subscribes :restart, "template[/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm]"
  log true
end

link "/etc/service/musicbrainz-server-renderer/mb_server" do
  to "/home/musicbrainz/musicbrainz-server"
  owner "musicbrainz"
end

link "/etc/service/musicbrainz-server/mb_server" do
  to "/home/musicbrainz/musicbrainz-server"
  owner "musicbrainz"
end

link "/etc/service/musicbrainz-ws/mb_server" do
  to "/home/musicbrainz/musicbrainz-server"
  owner "musicbrainz"
end

script "npm install" do
  user "musicbrainz"
  interpreter "bash"
  cwd "/home/musicbrainz/musicbrainz-server"
  environment "HOME" => "/home/musicbrainz"
  code "npm install"
  action :nothing
  subscribes :run, "git[/home/musicbrainz/musicbrainz-server]"
end

script "compile_resources" do
  user "musicbrainz"
  interpreter "bash"
  cwd "/home/musicbrainz/musicbrainz-server"
  environment "HOME" => "/home/musicbrainz"
  code "./script/compile_resources.sh"
  action :nothing
  subscribes :run, "git[/home/musicbrainz/musicbrainz-server]"
end

template "/etc/nginx/sites-available/musicbrainz" do
  source "nginx.conf.erb"
  user "root"
  variables(
    :listen_address => node['musicbrainz-server']['listen_address'],
    :server_name => node['musicbrainz-server']['hostname']
  )
  notifies :reload, "service[nginx]"
end

nginx_site "musicbrainz" do
  action :nothing
  subscribes :enable, "template[/etc/nginx/sites-available/musicbrainz]";
end
