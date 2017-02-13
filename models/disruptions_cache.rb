require 'redis'
$redis ||= Redis.new

class DisruptionsCache

  # Compare etags. If different then yield block and cache results. 
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
    results = $redis.get key
    return JSON.parse(results) if results

    new_results = yield
    $redis.set key, new_results.to_json
    $redis.expire key, seconds if seconds
    new_results
  end
end
