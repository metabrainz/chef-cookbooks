include_recipe "musicbrainz-server::install"

package "libmoosex-runnable-perl"
package "postgresql-client"
package "libwww-sitemap-xml-perl"

cron "daily" do
    minute "10"
    hour "0"
    command "/home/musicbrainz/musicbrainz-server/admin/cron/daily.sh"
    action :create
    user "musicbrainz"
    mailto "root"
end

cron "hourly" do
    minute "0"
    command "/home/musicbrainz/musicbrainz-server/admin/cron/hourly.sh"
    action :create
    user "musicbrainz"
    mailto "root"
end

cron "hourly-sitemaps" do
    minute "30"
    command "/home/musicbrainz/musicbrainz-server/admin/cron/hourly-sitemaps.sh"
    action :create
    user "musicbrainz"
    mailto "root"
end
