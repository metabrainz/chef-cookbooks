include_recipe "logster"

package "git"
git "/home/musicbrainz/logster" do
    repository "git://github.com/metabrainz/logster.git"
    revision "master"
    action :sync
    user "musicbrainz"
end

logster_log "/var/log/nginx/001-musicbrainz.access.log" do
    prefix "logster.#{node['hostname']}.mbserver"
    output "graphite"
    graphite_host node['graphite']['host']
    parser "musicbrainz.logster.NginxStatus.NginxStatus"
    python_path ["/home/musicbrainz/logster"]
end

# logster needs to be able to read nginx logs
group "adm" do
    append true
    action :modify
    members "logster"
end
