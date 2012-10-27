package "postgresql-9.1"
package "postgresql-contrib-9.1"

apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/oliver-charles/musicbrainz/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E4EB3B02925D4F66"
end

package "postgresql-musicbrainz-collate"
package "postgresql-musicbrainz-unaccent"

cookbook_file "/etc/postgresql/9.1/main/pg_hba.conf" do
  source "pg_hba.conf"
  owner "postgres"
end

service "postgresql" do
  action [:start,:reload]
end
