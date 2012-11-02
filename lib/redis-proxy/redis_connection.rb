class RedisConnection < EventMachine::Connection

  def initialize(config, client, request)
    @@nodes = config[:nodes] || []
    @@reconnect_limit = config[:reconnect_limit]
    @@reconnect_delay = config[:reconnect_delay]
    @node_id = 0;
    @last_alive_node = 0;
    @reconnect_count = 0;

    @client = client
    @request = request
  end

  def connection_completed
    puts "RedisConnection: connected to redis node: #{@node_id}"
    send_data "*1\r\n$4\r\nINFO\r\n"
  end

  def receive_data(data)
    if data =~ /role:master/
      puts "RedisConnection: connected to a master node, proxying"
      @last_alive_node = @node_id
      @reconnect_count = 0
      EventMachine.enable_proxy self, @client

      send_data @request
    else
      puts "RedisConnection: connected to a slave node, reconnecting"
      close_connection
    end
  end

  def proxy_target_unbound
    puts "RedisConnection: proxy target unbound"
    close_connection
  end

  def unbind
    puts "RedisConnection: connection unbound"

    EventMachine.disable_proxy self

    unless @client_unbind
      @node_id = (@node_id + 1) % @@nodes.count
      @reconnect_count += 1

      if @reconnect_count == @@reconnect_limit
        @client.close_connection_after_writing
      else
        if @node_id == @last_alive_node
          puts "RedisConnection: finished one reconnect cycle, sleeping before trying again"
          sleep @@reconnect_delay
        end
        reconnect @@nodes[@node_id][:host], @@nodes[@node_id][:port]
      end
    end
  end

  def client_unbind
    puts "RedisConnection: client unbind"
    EventMachine.disable_proxy self
    @client_unbind = true
    close_connection
  end

end
