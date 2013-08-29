include_recipe "apt"
apt_repository "govuk" do
  uri "http://ppa.launchpad.net/gds/govuk/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "B5A0E88F37FBE4E088598B31187FE15F914D5813"
end

package "collectd"

service "collectd" do
  supports [:start, :restart]
  action [:enable, :start]
end

template "/etc/collectd/collectd.conf" do
  action :create
  variables node['collectd']
  notifies :restart, "service[collectd]"
end
