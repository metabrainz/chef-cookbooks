include_recipe "daemontools"
include_recipe "caa-indexer::install"

daemontools_service "caa-indexer" do
  directory "/home/caaindexer/CAA-indexer/svc"
  template false
  action [:enable,:start]
end

template "/home/caaindexer/CAA-indexer/config.ini" do
  owner "caaindexer"
  mode "644"
  variables node['caa-indexer']
end

link "/home/caaindexer/CAA-indexer/svc/CAA-indexer" do
  to "/home/caaindexer/CAA-indexer"
end
