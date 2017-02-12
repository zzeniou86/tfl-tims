require 'sidekiq'
require 'json'

require_relative '../models/disruptions_document'
require_relative '../models/disruptions_cache'

class ParseWorker
  include Sidekiq::Worker

  def perform
    document_etag = DisruptionsDocument.get_etag("https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml")

    DisruptionsCache.cache(document_etag) do 
      document = DisruptionsDocument.new("https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml")
      document.parse_coordinates
    end

    self.class.perform_in 60
  end

end
