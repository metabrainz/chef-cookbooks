include_recipe "daemontools"
include_recipe "caa-indexer::install"

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "pgq-proxy" do
  directory "/home/caaindexer/pgq-proxy"
  template "pgq-proxy"
  action [:enable, :start]
  log true
end
