include_recipe "musicbrainz-server::install"

package "nodejs"
package "nodejs-legacy"
package "npm"

execute "compile_resources" do
  cd "/home/musicbrainz/musicbrainz-server/script"
  command "./compile_resources.pl"
  action :run
end

directory "/home/musicbrainz/bin" do
  owner "musicbrainz"
  group "musicbrainz"
  mode "0755"
  action :create
end

directory "/home/musicbrainz/lock" do
  owner "musicbrainz"
  group "musicbrainz"
  mode "0755"
  action :create
end

cookbook_file "/home/musicbrainz/bin/replicate" do
  source "replicate"
  group "musicbrainz"
  owner "musicbrainz"
  mode "0755"
end

cookbook_file "/home/musicbrainz/bin/check-replication-lock" do
  source "check-replication-lock"
  group "musicbrainz"
  owner "musicbrainz"
  mode "0755"
end

cookbook_file "/home/musicbrainz/lock/no-background-replication.lock" do
  source "no-background-replication.lock"
  group "musicbrainz"
  owner "musicbrainz"
  mode "0755"
end

cron "replicate" do
  minute "15"
  command "perl /home/musicbrainz/bin/check-replication-lock"
  action :create
  user "musicbrainz"
end
