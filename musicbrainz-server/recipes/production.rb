include_recipe "musicbrainz-server::server"

link "/home/musicbrainz/musicbrainz-server/root/robots.txt" do
  action :create
  to "/home/musicbrainz/musicbrainz-server/root/robots.txt.production"
end
