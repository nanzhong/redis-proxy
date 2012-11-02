class RedisProxyServer < EventMachine::Connection

  def initialize(redis_config)
    @@redis_config = redis_config
    @@default_node = redis_config[:nodes].first
  end

  def receive_data(data)

    if @proxy.nil?
      (@buffer ||= "") << data
      if @buffer =~ /\r\n/
        @proxy = EventMachine.connect @@default_node[:host], @@default_node[:port], RedisConnection, @@redis_config, self, data
      end
    else
      @proxy.send_data data
    end
  end

  def unbind
    puts "RedisProxy: unbind"
    @proxy.client_unbind
  end

end
