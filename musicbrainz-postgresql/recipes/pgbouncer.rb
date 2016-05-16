include_recipe "apt"
include_recipe "daemontools"

package "pgbouncer"

template "/etc/pgbouncer/userlist.txt"
template "/etc/pgbouncer/pgbouncer.ini"

daemontools_service "pgbouncer" do
  directory "/etc/service/pgbouncer"
  template "pgbouncer"
  action [:enable, :up]
  log true
end
