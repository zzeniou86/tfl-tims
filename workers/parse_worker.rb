require 'sidekiq'
require 'sidekiq/api'

require 'redis'
require 'json'

require_relative '../models/disruptions_document'

$redis ||= Redis.new

class ParseWorker
  include Sidekiq::Worker

  def perform
    document_etag = get_document_etag
    cached_etag = $redis.get "etag"
    
    if document_etag == cached_etag 
      puts "do nothing"
      self.class.perform_in 60
    else
      coords = parse_document
      $redis.set "coords", coords.to_json
      $redis.set "etag:#{document_etag}", coords.to_json
      $redis.set "etag", document_etag 
      puts "parse and cache"
      self.class.perform_in 60
    end

  end

  private
  def get_document_etag 
    url = URI('https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml')

    etag = nil
    Net::HTTP.start(url.host, url.port, use_ssl: true){|http|
      response = http.head(url.path)
      etag = response["etag"]
    }

    etag
  end

  def parse_document
    document = DisruptionsDocument.new("https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml")
    document.parse_coordinates
  end

end