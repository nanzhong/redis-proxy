require 'redis-proxy'

config = {
  reconnect_limit: 5,
  reconnect_delay: 5,
  nodes: [
    { host: 'nan-imac.local', port: 6379 },
    { host: 'nan-imac.local', port: 6380 }
  ]
}

RedisProxy.start(config)
