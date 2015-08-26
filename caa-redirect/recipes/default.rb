include_recipe "apt"

package "python-cherrypy3"
package "python-psycopg2"
package "python-sqlalchemy"
package "python-werkzeug"

service_name = node['caa-redirect'][:service]

user "caaredirect" do
  action :create
  home "/home/caaredirect"
  shell "/bin/bash"
  supports :manage_home => true
end

package "git"
git "/home/caaredirect/#{service_name}" do
  repository "git://github.com/metabrainz/coverart_redirect.git"
  revision node['caa-redirect'][:revision]
  action :sync
  user "caaredirect"
end

template "/home/caaredirect/#{service_name}/coverart_redirect.conf" do
  owner "caaredirect"
  mode "644"
  variables :config => node['caa-redirect']
end

include_recipe "daemontools"
service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

daemontools_service "caa-redirect" do
  directory "/home/caaredirect/svc-#{service_name}"
  template "coverart_redirect"
  log true
  action [:enable, :start]
end

link "/home/caaredirect/svc-#{service_name}/coverart_redirect" do
  to "/home/caaredirect/#{service_name}"
end
