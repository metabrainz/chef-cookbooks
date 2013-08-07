include_recipe "sudo"
package "libshadow-ruby1.8"

chef_gem "ruby-shadow" do
  action :install
end

user "vm" do
  action :create
  home "/home/vm"
  password "$6$rR45kuEs$52XtXnmlMRdW4cHZ9mOmTlx/wtqhumRcYYxyecXepF0C1.lVcvkl7UFZJ3HwWDdaAXYu6Mm0e7t0SLzhdXqiN1"
  shell "/bin/bash"
  supports :manage_home => true
end

sudo "vm" do
  user "vm"
  nopasswd true
end

sudo "search" do
  user "search"
  nopasswd true
end

directory "/home/vm/bin" do
  owner "vm"
  group "vm"
  mode "0755"
  action :create
end

cookbook_file "/home/vm/bin/replicate" do
  source "replicate"
  group "vm"
  owner "vm"
  mode "0755"
end

cookbook_file "/home/vm/bin/reindex" do
  source "reindex"
  group "vm"
  owner "vm"
  mode "0755"
end

cookbook_file "/etc/postgresql/9.1/main/postgresql.conf.in" do
  source "postgresql.conf.in"
  owner "postgres"
  group "postgres"
  mode "0644"
end

cookbook_file "/etc/init.d/postgresql-config" do
  source "postgresql-config"
  owner "root"
  group "root"
  mode "0755"
end

link "/etc/rc2.d/S18postgresql-config" do
  to "/etc/init.d/postgresql-config"
end

link "/etc/rc3.d/S18postgresql-config" do
  to "/etc/init.d/postgresql-config"
end

file "/etc/postgresql/9.1/main/postgresql.conf" do
  action :delete
end

cookbook_file "/usr/local/bin/tune_pg.py" do
  source "tune_pg.py"
  owner "root"
  group "root"
  mode "0755"
end

service "postgresql-config" do
  action [ :start ]
end

service "postgresql" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start, :reload ]
end
