include_recipe "apt"
include_recipe "daemontools"

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

service "svscan" do
  action :start
  provider Chef::Provider::Service::Upstart
end

['production', 'staging'].each do |server|
  service_name = "coverart_redirect-#{server}"

  package "git"
  git "/home/caaredirect/#{service_name}" do
    repository "git://github.com/metabrainz/coverart_redirect.git"
    revision node['caa-redirect'][server.to_sym][:revision]
    action :sync
    user "caaredirect"
  end

  template "/home/caaredirect/#{service_name}/coverart_redirect.conf" do
    owner "caaredirect"
    mode "644"
    variables(
      :config => node['caa-redirect'],
      :server => server
    )
  end

  daemontools_service "#{service_name}" do
    directory "/home/caaredirect/svc-#{service_name}"
    template "coverart_redirect"
    log true
    action [:enable, :start]
  end

  link "/home/caaredirect/svc-#{service_name}/coverart_redirect" do
    to "/home/caaredirect/#{service_name}"
  end
end
