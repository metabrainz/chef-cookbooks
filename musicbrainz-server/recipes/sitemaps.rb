include_recipe "musicbrainz-server::packages"

apt_repository "apt.postgresql.org" do
  uri "http://apt.postgresql.org/pub/repos/apt"
  distribution "trusty-pgdg"
  components ["main"]
  key "https://www.postgresql.org/media/keys/ACCC4CF8.asc"
end

package "postgresql-9.4"
package "postgresql-server-dev-9.4"
package "postgresql-contrib-9.4"
package "postgresql-plperl-9.4"

template "/etc/postgresql/9.4/main/pg_hba.conf" do
  source "sitemaps-pg_hba.conf.erb"
  owner "postgres"
  mode "640"
end

user "setting postgres password" do
  username "postgres"
  password node['musicbrainz-server']['sitemaps']['postgres_password']
  action :modify
end

script "createuser sitemaps" do
  user "postgres"
  interpreter "bash"
  cwd "/home/postgres"
  code "createuser sitemaps"
  action :run
end

user "sitemaps" do
  action :create
  home "/home/sitemaps"
  shell "/bin/bash"
  supports :manage_home => true
  password node['musicbrainz-server']['sitemaps']['sitemaps_password']
end

git "/home/sitemaps/musicbrainz-server" do
  repository "git://github.com/metabrainz/musicbrainz-server.git"
  action :sync
  user "sitemaps"
  revision "production"
  enable_submodules true
end

template "/home/sitemaps/musicbrainz-server/lib/DBDefs.pm" do
  source "sitemaps-DBDefs.pm.erb"
  owner "sitemaps"
  mode "644"
end

cron "daily" do
  minute "10"
  hour "0"
  command "/home/sitemaps/musicbrainz-server/admin/cron/daily-sitemaps.sh"
  action :create
  user "sitemaps"
  mailto "root"
end

cron "hourly" do
  minute "30"
  command "/home/sitemaps/musicbrainz-server/admin/cron/hourly-sitemaps.sh"
  action :create
  user "sitemaps"
  mailto "root"
end

template "/etc/nginx/sites-available/sitemaps" do
  source "sitemaps-nginx.conf.erb"
  user "root"
  notifies :reload, "service[nginx]"
end

package "libplack-perl"
daemontools_service "musicbrainz-server" do
  directory "/home/sitemaps/svc-musicbrainz-server"
  template "sitemaps-musicbrainz-server"
  action [:enable, :up]
  log false
end
