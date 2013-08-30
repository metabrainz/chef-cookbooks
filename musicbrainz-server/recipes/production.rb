include_recipe "daemontools"
include_recipe "musicbrainz-server::install"
include_recipe "nginx"
include_recipe "nodejs"

package "libcatalyst-plugin-autorestart-perl"
package "libcatalyst-plugin-errorcatcher-perl"
package "libfcgi-procmanager-perl"
package "libjavascript-closure-perl"

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "musicbrainz-server" do
  directory "/home/musicbrainz/svc-musicbrainz-server"
  template "musicbrainz-server"
  variables :nproc => node['musicbrainz-server']['nproc']
  action [:enable,:start]
  subscribes :restart, "git[/home/musicbrainz/musicbrainz-server]" 
  subscribes :restart, "template[/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm]"
  log true
end

link "/etc/service/musicbrainz-server/mb_server" do
  to "/home/musicbrainz/musicbrainz-server"
  owner "musicbrainz"
end

script "npm install" do
  user "musicbrainz"
  interpreter "bash"
  cwd "/home/musicbrainz/musicbrainz-server"
  code "HOME=/home/musicbrainz npm install"
  subscribes :run, "git[/home/musicbrainz/musicbrainz-server]"
end

script "compile_resources" do
  user "musicbrainz"
  interpreter "bash"
  cwd "/home/musicbrainz/musicbrainz-server"
  code "./script/compile_resources.pl"
  subscribes :run, "git[/home/musicbrainz/musicbrainz-server]"
end

template "/etc/nginx/sites-available/musicbrainz" do
  source "nginx.conf.erb"
  user "root"
  variables :server_name => node['musicbrainz-server']['hostname'];
end

nginx_site "musicbrainz" do
  action :nothing
  subscribes :enable, "template[/etc/nginx/sites-available/musicbrainz]";
end

link "/home/musicbrainz/musicbrainz-server/root/robots.txt" do
  action :create
  to "/home/musicbrainz/musicbrainz-server/root/robots.txt.production"
end
