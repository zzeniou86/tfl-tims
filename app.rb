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
    @maps_key = configatron.google_maps_key
    @list = DisruptionsCache.fetch("coords", 60) do
      # Can be used for standalone use without sidekiq, or as failsafe when something goes wrong with sidekiq      .
      document = DisruptionsDocument.new(configatron.disruptions_url, configatron.disruptions_xpath)
      document.parse_coordinates
    end
    erb :index
  end
end
