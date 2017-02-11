$stdout.sync = true

require 'sinatra/base'
require 'sidekiq'
require 'redis'
require 'sidekiq/api'
require 'json'

require 'models/disruptions_document'

class Quiqup < Sinatra::Base
  get "/" do
    document = DisruptionsDocument.new("https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml")
    @list = document.parse_coordinates
    erb :index
  end
end