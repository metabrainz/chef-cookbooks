user "search" do
  action :create
  home "/home/search"
  shell "/bin/bash"
  supports :manage_home => true
end

package "openjdk-7-jdk"

directory "/home/search/indexdata" do
  owner "search"
  group "search"
  mode "0755"
  action :create
end

directory "/home/search/jar" do
  owner "search"
  group "search"
  mode "0755"
  action :create
end

directory "/home/search/bin" do
  owner "search"
  group "search"
  mode "0755"
  action :create
end

remote_file "/home/search/jar/index.jar" do
  source "http://ftp.musicbrainz.org/pub/musicbrainz/search/index/index.jar" 
  group "search"
  owner "search"
  mode "0644"
end

cookbook_file "/home/search/bin/reindex" do
  source "reindex"
  group "search"
  owner "search"
  mode "0755"
end

package "jetty"

remote_file "/var/lib/jetty/webapps/root.war" do
  source "http://ftp.musicbrainz.org/pub/musicbrainz/search/servlet/searchserver.war" 
  group "jetty"
  owner "jetty"
  mode "0644"
end

cookbook_file "/etc/default/jetty" do
  source "jetty.default"
  group "root"
  owner "root"
  mode "0755"
end

service "jetty" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start, :reload ]
end
