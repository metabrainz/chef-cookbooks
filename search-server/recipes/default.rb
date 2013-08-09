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
  action :create_if_missing
end

cookbook_file "/home/search/bin/reindex" do
  source "reindex"
  group "search"
  owner "search"
  mode "0755"
end

package "jetty"

remote_file "/var/lib/jetty/webapps/ROOT.war" do
  source "http://ftp.musicbrainz.org/pub/musicbrainz/search/servlet/searchserver.war" 
  group "jetty"
  owner "jetty"
  mode "0644"
  action :create_if_missing
end

directory "/var/lib/jetty/webapps/root" do
  owner "jetty"
  group "jetty"
  mode "0755"
  action :create
end

execute "jar" do
  cwd "/var/lib/jetty/webapps/root"
  command "jar -xf ../ROOT.war"
  creates "/var/lib/jetty/webapps/root/META-INF"
  action :run
end

cookbook_file "/etc/default/jetty" do
  source "jetty.default"
  group "root"
  owner "root"
  mode "0755"
end

bash "java_home" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  echo "JAVA_HOME="`readlink -f $( dirname $( readlink -f $( which java ) ) )/../..` >> /etc/default/jetty
  EOH
end

service "jetty" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
