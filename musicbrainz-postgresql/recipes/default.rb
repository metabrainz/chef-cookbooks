include_recipe "apt"
include_recipe "postgresql::server"

apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "D58E52C99814760488A38D87E3446F96A3FB3557"
end

package "postgresql-musicbrainz-collate"
package "postgresql-musicbrainz-unaccent"
