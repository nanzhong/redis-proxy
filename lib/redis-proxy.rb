require 'eventmachine'
require 'redis-proxy/redis_connection'
require 'redis-proxy/redis_proxy_server'

class RedisProxy

  def self.start(redis_config, host = "0.0.0.0", port = 6379, options = {})
    EventMachine.epoll
    EventMachine.run do
      puts "Starting up redis proxy server"
      EventMachine.start_server host, port, RedisProxyServer, redis_config
    end
  end

  def self.stop
    puts "Terminating redis proxy server"
    EventMachine.stop
  end

end
