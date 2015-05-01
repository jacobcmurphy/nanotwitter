require 'redis'

module RedisConnect
@@r = Redis.new

  def get_from_redis(key)
     if @@r.get(key).nil?
      result =  yield
      @@r.set key, result
      @@r.expire key, 10
      return result
    end
    return @@r.get key
  end
end
