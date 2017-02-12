require 'redis'
$redis ||= Redis.new

class DisruptionsCache

  def self.cache(doc_etag)
    cached_etag = $redis.get "etag"
    if doc_etag != cached_etag 
        coords = yield
        $redis.set "coords", coords.to_json
        $redis.set "etag:#{doc_etag}", coords.to_json
        $redis.set "etag", doc_etag
    end      
  end

  def self.fetch(key, seconds)
    cached_coords = $redis.get key
    return JSON.parse(cached_coords) if cached_coords

    new_coords = yield
    $redis.set key, new_coords.to_json
    $redis.expire key, seconds if seconds
    new_coords
  end
end
