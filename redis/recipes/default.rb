package "redis-server"

template "/etc/redis/redis.conf"

service "redis-server" do
  action [:enable, :start]
end
