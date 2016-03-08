user "musicbrainz" do
  action :create
  home "/home/musicbrainz"
  shell "/bin/bash"
  supports :manage_home => true
end

group "www-data" do
  action :modify
  append true
  members [ "musicbrainz" ]
end

include_recipe "musicbrainz-server::packages"

git "/home/musicbrainz/musicbrainz-server" do
  repository "git://github.com/metabrainz/musicbrainz-server.git"
  action :sync
  user "musicbrainz"
  revision node['musicbrainz-server']['revision']
  enable_submodules true
end

template "/home/musicbrainz/musicbrainz-server/lib/DBDefs.pm" do
  owner "musicbrainz"
  mode "644"
  variables "dbdefs" => node['musicbrainz-server']['dbdefs']
end
