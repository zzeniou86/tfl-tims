$stdout.sync = true

require 'sinatra/base'
require 'sidekiq'
require 'redis'
require 'sidekiq/api'
require 'nokogiri'
require 'open-uri'

class Quiqup < Sinatra::Base
  get "/" do
    doc = Nokogiri::XML(open("https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml"))
    @list = doc.xpath("//xmlns:Disruptions/xmlns:Disruption/xmlns:CauseArea/xmlns:DisplayPoint/xmlns:Point/xmlns:coordinatesLL").map do |node|
      lng,lat = node.text.split(",")
      {lat: lat.to_f, lng: lng.to_f}
    end
    erb :index
  end
end