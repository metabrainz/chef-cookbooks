include_recipe "musicbrainz-postgresql"

include_recipe "apt"

apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "D58E52C99814760488A38D87E3446F96A3FB3557"
end

package "postgresql-dbmirror"

# Contains PgQ 2
package "skytools-modules-9.1"

# Needed for searching JSON values
package "postgresql-plperl-9.1"
package "libjson-xs-perl"
