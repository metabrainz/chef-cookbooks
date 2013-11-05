include_recipe "daemontools"
include_recipe "musicbrainz-server::install"

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "musicbrainz-server" do
  directory "/home/musicbrainz/musicbrainz-server/admin/nginx/service-standalone/"
  template false
  action [:enable,:start]
  subscribes :restart, "git[/home/musicbrainz/musicbrainz-server]" 
  subscribes :restart, "template[/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm]"
end

link "/etc/service/musicbrainz-server/mb_server" do
  to "/home/musicbrainz/musicbrainz-server"
  owner "musicbrainz"
end
