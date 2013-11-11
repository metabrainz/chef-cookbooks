include_recipe "apt"
include_recipe "postgresql::server"

apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E4EB3B02925D4F66"
end

package "postgresql-musicbrainz-collate"
package "postgresql-musicbrainz-unaccent"
