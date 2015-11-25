include_recipe "apt"
include_recipe "daemontools"

package "fabric"
package "git"
package "nodejs"
package "python-cherrypy3"
package "python-psycopg2"
package "python-sqlalchemy"
package "python-werkzeug"

apt_repository "nodejs" do
  uri "https://deb.nodesource.com/node_4.x"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "1655a0ab68576280"
end

user "caaredirect" do
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

  git "/home/caaredirect/#{service_name}" do
    repository "git://github.com/metabrainz/coverart_redirect.git"
    revision node['caa-redirect'][server.to_sym][:revision]
    user "caaredirect"
  end

  template "/home/caaredirect/#{service_name}/coverart_redirect.conf" do
    owner "caaredirect"
    mode "644"
    variables(
      :config => node['caa-redirect'],
      :server => server
    )
    notifies :restart, "daemontools_service[#{service_name}]"
  end

  script "compile_resources" do
    user "caaredirect"
    interpreter "bash"
    cwd "/home/caaredirect/#{service_name}"
    environment ({
      "HOME" => "/home/caaredirect", 
      "PATH" => "/home/caaredirect/#{service_name}/node_modules/.bin:#{ENV['PATH']}",
    })
    code <<-EOH
      npm install
      fab compile_styling
      EOH
    action :nothing
    subscribes :run, "git[/home/caaredirect/#{service_name}]"
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
