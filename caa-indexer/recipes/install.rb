user "caaindexer" do
  action :create
  home "/home/caaindexer"
  shell "/bin/bash"
  supports :manage_home => true
end

package "git"
git "/home/caaindexer/CAA-indexer" do
  repository "git://github.com/metabrainz/CAA-indexer.git"
  revision "master"
  action :sync
  user "caaindexer"
end

package "libanyevent-perl"
package "libconfig-tiny-perl"
package "libdbd-pg-perl"
package "libdbix-simple-perl"
package "libjson-any-perl"
package "liblog-contextual-perl"
package "libnet-amazon-s3-perl"
package "libtry-tiny-perl"
package "libwww-perl"
package "libxml-xpath-perl"

include_recipe "apt"
apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "D58E52C99814760488A38D87E3446F96A3FB3557"
end

package "libnet-rabbitfoot-perl"
