include_recipe "musicbrainz-server::install"

cron "replicate" do
  minute "0"
  command "perl /home/musicbrainz/musicbrainz-server/admin/replication/LoadReplicationChanges"
  action :create
end
