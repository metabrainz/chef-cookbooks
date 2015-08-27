include_recipe "apt"
include_recipe "daemontools"

package "redis-server"

template "/etc/redis/redis.conf"

daemontools_service "redis-server" do
  directory "/var/lib/redis/redis-server"
  template "redis-server"
  action [:enable, :start]
  log true
end
