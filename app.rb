$stdout.sync = true

require 'sinatra/base'
require 'redis'
require 'json'

require './models/disruptions_document'
require './models/disruptions_cache'

$redis ||= Redis.new

class Quiqup < Sinatra::Base
  get "/" do
    @list = DisruptionsCache.fetch("coords", 60) do
      #failsafe code in case something goes wrong with worker / cache
      document = DisruptionsDocument.new("https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml")
      document.parse_coordinates
    end
    erb :index
  end
end
