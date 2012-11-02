Gem::Specification.new do |s|
  s.name     = "redis-proxy"
  s.summary  = "A simple redis proxy that handles reconnection and sentinel failover"
  s.version  = "0.0.1"
  s.author   = "Nan Zhong"
  s.email    = "nan@nine27.com"
  s.homepage = 'https://github.com/nanzhong/redis-proxy'

  s.files    = `git ls-files`.split($\)

  s.add_dependency "eventmachine"
end
