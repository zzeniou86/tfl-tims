require 'redis'
$redis ||= Redis.new

class DisruptionsCache

  # Compare etags. If different then yield block and cache results. 
  def self.cache(doc_etag)
    cached_etag = $redis.get "etag"
    if doc_etag != cached_etag 
        coords = yield
        $redis.set "coords", coords.to_json
        # Comment the following two lines of code if we don't need to store historical data 
        $redis.set "etag:#{doc_etag}", coords.to_json
        $redis.expire "etag:#{doc_etag}", 86400
        $redis.set "etag", doc_etag
        $redis.expire "etag", 600
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
