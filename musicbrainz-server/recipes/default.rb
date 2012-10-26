package "git"
package "liblocal-lib-perl"

package "build-essential"
package "libxml2-dev"
package "libpq-dev"
package "libexpat1-dev"
package "libdb-dev"

package "libalgorithm-diff-perl"
package "libalgorithm-merge-perl"
package "libcache-memcached-perl"
package "libcaptcha-recaptcha-perl"
package "libcatalyst-modules-perl"
package "libcatalyst-perl"
package "libcatalyst-view-tt-perl"
package "libclone-perl"
package "libcss-minifier-perl"
package "libmoose-perl"
package "libdata-compare-perl"
package "libdata-dumper-concise-perl"
package "libdata-optlist-perl"
package "libdata-page-perl"
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
package "libemail-address-perl"
package "libemail-mime-creator-perl"
package "libemail-mime-perl"
package "libemail-sender-perl"
package "libemail-valid-perl"
package "libencode-detect-perl"
package "libexception-class-perl"
package "libhtml-tiny-perl"
package "libhtml-treebuilder-xpath-perl"
package "libintl-perl"
package "libio-all-perl"
package "libjson-perl"
package "libjson-xs-perl"
package "liblist-moreutils-perl"
package "liblist-utilsby-perl"
package "liblog-dispatch-perl"
package "libmethod-signatures-simple-perl"
package "libmodule-pluggable-perl"
package "libmoosex-clone-perl"
package "libmoosex-getopt-perl"
package "libmoosex-methodattributes-perl"
package "libmoosex-role-parameterized-perl"
package "libmoosex-singleton-perl"
package "libmoosex-types-perl"
package "libmoosex-types-structured-perl"
package "libmro-compat-perl"
package "libpackage-stash-perl"
package "libreadonly-perl"
package "libstatistics-basic-perl"
package "libstring-camelcase-perl"
package "libstring-shellquote-perl"
package "libtemplate-plugin-class-perl"
package "libtemplate-plugin-javascript-perl"
package "libtext-trim-perl"
package "libtext-unaccent-perl"
package "libtext-wikiformat-perl"
package "libthrowable-perl"
package "libtime-duration-perl"
package "libtrycatch-perl"
package "liburi-perl"
package "libxml-generator-perl"
package "libxml-semanticdiff-perl"
package "libxml-simple-perl"
package "libxml-xpath-perl"

package "libcache-memcached-fast-perl"
package "libcache-perl"
package "libcatalyst-plugin-unicode-encoding-perl"
package "libdigest-md5-file-perl"
package "libset-scalar-perl"
package "libsoap-lite-perl"

# Indirect dependencies
package "libcache-memcached-managed-perl"
package "libtest-use-ok-perl"
package "libdata-uuid-perl"
package "libstring-escape-perl"
package "liblist-allutils-perl"
package "libobject-insideout-perl"
package "libfile-sharedir-install-perl"
package "libtest-differences-perl"
package "libtest-memory-cycle-perl"
package "libtest-fatal-perl"
package "libmoosex-types-path-class-perl"

user "musicbrainz" do
  action :create
  home "/home/musicbrainz"
  shell "/bin/bash"
  supports :manage_home => true
end

git "/home/musicbrainz/musicbrainz-server" do
  repository "http://github.com/metabrainz/musicbrainz-server.git"
  revision "master"
  action :sync
  user "musicbrainz"
end


apt_repository "musicbrainz" do
  uri "http://ppa.launchpad.net/oliver-charles/musicbrainz/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "E4EB3B02925D4F66"
end

package "libcatalyst-plugin-cache-http-perl"
package "libcatalyst-plugin-session-store-memcached-perl"
package "libcatalyst-authentication-credential-http-perl"
package "libdata-uuid-mt-perl"

# package "libhtml-formhandler-perl"
# package "libjavascript-closure-perl"
# package "libmoosex-abc-perl"
# package "libmoosex-runnable-perl"
# package "libmoosex-types-uri-perl"
# package "libnet-amazon-awssign-perl"
# package "libnet-amazon-s3-policy-perl"
# package "libnet-coverartarchive-perl"
# package "librest-utils-perl"
# package "libstring-tt-perl"
# package "libtemplate-plugin-map-perl"
# package "libtemplate-plugin-math-perl"
# package "libxml-parser-lite-perl"
# package "libxml-rss-parser-lite-perl"

# requires 'Catalyst::Plugin::I18N'                     => '0.09';
# requires 'Catalyst::Plugin::Unicode::Encoding'        => '1.2';
# requires 'CGI::Expand';

# # Prefer Digest::SHA
# requires 'Digest::SHA1'                               => '2.110';

