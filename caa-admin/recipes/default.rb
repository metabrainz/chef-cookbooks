include_recipe "cabal"

user "caaadmin" do
  action :create
  home "/home/caaadmin"
  shell "/bin/bash"
  supports :manage_home => true
end

cabal_install "caa-admin" do
  github "metabrainz/caa-admin"
  user "caaadmin"
  cabal_update true
  install_binary :from => 'dist/build/caa-admin/caa-admin', :to => '/usr/bin/caa-admin'
  force_reinstalls true
end

include_recipe "daemontools"
service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "caa-admin" do
  directory "/home/caaadmin/svc-caa-admin"
  template "caa-admin"
  log true
  action [:enable, :start]
end
