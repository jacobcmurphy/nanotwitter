require 'redis'

module RedisConnect

  def get_from_redis(key)
	r ||= Redis.new
     if r.get(key).nil?
      result =  yield
      r.set key, result
      r.expire key, 10
      return r.get key
    end
    return r.get key
  end
end
