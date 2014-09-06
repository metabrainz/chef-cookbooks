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

package "git"
git "/home/musicbrainz/musicbrainz-server" do
  repository "git://github.com/metabrainz/musicbrainz-server.git"
  revision "master"
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

include_recipe "apt"
apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/metabrainz/musicbrainz-server/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "D58E52C99814760488A38D87E3446F96A3FB3557"
end

package "libxml2-dev"
package "libpq-dev"
package "libexpat1-dev"
package "libicu-dev"
package "libdb-dev"

package "libalgorithm-diff-perl"
package "libalgorithm-merge-perl"
package "libauthen-passphrase-perl"
package "libcache-memcached-fast-perl"
package "libcache-memcached-perl"
package "libcache-perl"
package "libcaptcha-recaptcha-perl"
package "libcatalyst-authentication-credential-http-perl"
package "libcatalyst-modules-perl"
package "libcatalyst-perl"
package "libcatalyst-plugin-cache-http-perl"
package "libcatalyst-plugin-session-store-memcached-perl"
package "libcatalyst-plugin-unicode-encoding-perl"
package "libcatalyst-view-tt-perl"
package "libcgi-expand-perl"
package "libclone-perl"
package "libdata-compare-perl"
package "libdata-dumper-concise-perl"
package "libdata-optlist-perl"
package "libdata-page-perl"
package "libdata-uuid-mt-perl"
package "libdate-calc-perl"
package "libdatetime-format-duration-perl"
package "libdatetime-format-iso8601-perl"
package "libdatetime-format-natural-perl"
package "libdatetime-format-pg-perl"
package "libdatetime-timezone-perl"
package "libdbd-pg-perl"
package "libdbi-perl"
package "libdbix-connector-perl"
package "libdigest-hmac-perl"
package "libdigest-md5-file-perl"
package "libdigest-sha-perl"
package "libemail-address-perl"
package "libemail-mime-creator-perl"
package "libemail-mime-perl"
package "libemail-sender-perl"
package "libemail-valid-perl"
package "libencode-detect-perl"
package "libexception-class-perl"
package "libgnupg-perl"
package "libhtml-formhandler-perl"
package "libhtml-tiny-perl"
package "libhtml-treebuilder-xpath-perl"
package "libintl-perl"
package "libio-all-perl"
package "libjson-perl"
package "libjson-xs-perl"
package "liblist-allutils-perl"
package "liblist-moreutils-perl"
package "liblist-utilsby-perl"
package "liblog-dispatch-perl"
package "libmath-random-secure-perl"
package "libmethod-signatures-simple-perl"
package "libmodule-pluggable-perl"
package "libmoose-perl"
package "libmoosex-abc-perl"
package "libmoosex-clone-perl"
package "libmoosex-getopt-perl"
package "libmoosex-methodattributes-perl"
package "libmoosex-role-parameterized-perl"
package "libmoosex-singleton-perl"
package "libmoosex-types-perl"
package "libmoosex-types-uri-perl"
package "libmoosex-types-structured-perl"
package "libmro-compat-perl"
package "libnet-amazon-awssign-perl"
package "libnet-amazon-s3-policy-perl"
package "libnet-coverartarchive-perl"
package "libpackage-stash-perl"
package "libreadonly-perl"
package "libredis-perl"
package "librest-utils-perl"
package "libset-scalar-perl"
package "libsoap-lite-perl"
package "libstatistics-basic-perl"
package "libstring-camelcase-perl"
package "libstring-shellquote-perl"
package "libstring-tt-perl"
package "libtemplate-plugin-class-perl"
package "libtemplate-plugin-javascript-perl"
package "libtemplate-plugin-json-escape-perl"
package "libtext-trim-perl"
package "libtext-unaccent-perl"
package "libtext-wikiformat-perl"
package "libthrowable-perl"
package "libtime-duration-perl"
package "libtrycatch-perl"
package "libunicode-icu-collator-perl"
package "liburi-perl"
package "libxml-generator-perl"
package "libxml-rss-parser-lite-perl"
package "libxml-semanticdiff-perl"
package "libxml-simple-perl"
package "libxml-xpath-perl"
