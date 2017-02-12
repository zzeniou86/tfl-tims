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
  
end