$stdout.sync = true

require 'sinatra/base'
require 'sidekiq'
require 'redis'
require 'sidekiq/api'
require 'json'

require './models/disruptions_document'

$redis ||= Redis.new

class Quiqup < Sinatra::Base
  get "/" do
    @list = get_coords
    erb :index
  end
end


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

def get_coords
  document_etag = get_document_etag
  cached_etag = $redis.get "etag"
  
  if document_etag == cached_etag 
    coords = $redis.get "etag:#{document_etag}"
    coords = JSON.parse(coords)
  else
    coords = parse_document
    $redis.set "etag:#{document_etag}", coords.to_json
    $redis.set "etag", document_etag 
    coords
  end
end
