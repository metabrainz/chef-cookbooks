user "caaindexer" do
  action :create
  home "/home/caaindexer"
  shell "/bin/bash"
  supports :manage_home => true
end

package "git"
git "/home/caaindexer/CAA-indexer" do
  repository "git://github.com/metabrainz/CAA-indexer.git"
  revision "rabbitmq"
  action :sync
  user "caa"
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
package "libnet-rabbitfoot-perl"
