$stdout.sync = true

require 'sinatra/base'
require 'redis'
require 'json'

require './models/disruptions_document'
require './models/disruptions_cache'

require './config/settings'

$redis ||= Redis.new

class Quiqup < Sinatra::Base
  get "/" do
    @list = DisruptionsCache.fetch("coords", 60) do
      #failsafe code in case something goes wrong with worker / cache
      document = DisruptionsDocument.new(configatron.disruptions_url, configatron.disruptions_xpath)
      document.parse_coordinates
    end
    @maps_key = configatron.google_maps_key
    erb :index
  end
end
