include_recipe "daemontools"
include_recipe "musicbrainz-server::install"
include_recipe "nginx"

package "libcatalyst-plugin-autorestart-perl"
package "libcatalyst-plugin-errorcatcher-perl"
package "libstarlet-perl"

script "make_po" do
  user "musicbrainz"
  interpreter "bash"
  cwd "/home/musicbrainz/musicbrainz-server"
  environment "HOME" => "/home/musicbrainz"
  code <<-EOH
    make -C po all_quiet
    make -C po deploy
    EOH
  action :nothing
  subscribes :run, "git[/home/musicbrainz/musicbrainz-server]"
end

script "compile_resources" do
  user "musicbrainz"
  interpreter "bash"
  cwd "/home/musicbrainz/musicbrainz-server"
  environment "HOME" => "/home/musicbrainz"
  code <<-EOH
    npm install
    ./script/compile_resources.sh
    EOH
  action :nothing
  subscribes :run, "git[/home/musicbrainz/musicbrainz-server]"
end

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "musicbrainz-server-renderer" do
  directory "/home/musicbrainz/svc-musicbrainz-server-renderer"
  template "musicbrainz-server-renderer"
  variables :port => node['musicbrainz-server']['renderer-port']
  action [:enable, :up]
  subscribes :restart, "git[/home/musicbrainz/musicbrainz-server]"
  log false
end

daemontools_service "musicbrainz-server" do
  directory "/home/musicbrainz/svc-musicbrainz-server"
  template "musicbrainz-server"
  variables :nproc => node['musicbrainz-server']['nproc-website']
  action [:enable, :up]
  subscribes :hup, "git[/home/musicbrainz/musicbrainz-server]"
  subscribes :hup, "template[/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm]"
  log true
end

daemontools_service "musicbrainz-ws" do
  directory "/home/musicbrainz/svc-musicbrainz-ws"
  template "musicbrainz-ws"
  variables :nproc => node['musicbrainz-server']['nproc-ws']
  action [:enable, :up]
  subscribes :hup, "git[/home/musicbrainz/musicbrainz-server]"
  subscribes :hup, "template[/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm]"
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

template "/etc/nginx/sites-available/musicbrainz" do
  source "nginx.conf.erb"
  user "root"
  variables(
    :listen_address => node['musicbrainz-server']['listen_address'],
    :server_name => node['musicbrainz-server']['hostname']
  )
  notifies :reload, "service[nginx]"
end

template "/etc/nginx/sites-available/nginxstatus" do
  source "nginxstatus.conf.erb"
  user "root"
  notifies :reload, "service[nginx]"
end

nginx_site "musicbrainz" do
  action :nothing
  subscribes :enable, "template[/etc/nginx/sites-available/musicbrainz]";
end

nginx_site "nginxstatus" do
  action :nothing
  subscribes :enable, "template[/etc/nginx/sites-available/nginxstatus]";
end
