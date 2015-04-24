include_recipe "apt"

package "pgbouncer"

template "/usr/local/pgbouncer/etc/auth_file"
template "/usr/local/pgbouncer/etc/pgbouncer.ini"

execute "Enable pgbouncer" do
  command "/bin/sed s/START=0/START=1/ -i /etc/default/pgbouncer"
  not_if "grep 'START=0' /etc/default/pgbouncer"
  only_if { platform_family?("debian") }
end

service "pgbouncer" do
  supports restart: true
  action [ :enable, :start ]
end
