include_recipe "apt"
include_recipe "daemontools"

package "pgbouncer"

template "/etc/pgbouncer/userlist.txt"
template "/etc/pgbouncer/pgbouncer.ini"

execute "Disable pgbouncer init script" do
  command "/bin/sed s/START=1/START=0/ -i /etc/default/pgbouncer"
  not_if "grep 'START=1' /etc/default/pgbouncer"
  only_if { platform_family?("debian") }
end

daemontools_service "pgbouncer" do
  directory "/etc/service/pgbouncer"
  template "pgbouncer"
  action [:enable, :up]
  log true
end
