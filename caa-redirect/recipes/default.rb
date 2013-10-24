include_recipe "apt"

package "python-cherrypy3"
package "python-psycopg2"
package "python-sqlalchemy"
package "python-werkzeug"

user "caaredirect" do
  action :create
  home "/home/caaredirect"
  shell "/bin/bash"
  supports :manage_home => true
end

package "git"
git "/home/caaredirect/coverart_redirect" do
  repository "git://github.com/metabrainz/coverart_redirect.git"
  revision "master"
  action :sync
  user "caaredirect"
end

template "/home/caaredirect/coverart_redirect/coverart_redirect.conf" do
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
  directory "/home/caaredirect/svc-coverart_redirect"
  template "coverart_redirect"
  log true
  action [:enable, :start]
end

link "/home/caaredirect/svc-coverart_redirect/coverart_redirect" do
  to "/home/caaredirect/coverart_redirect"
end 
