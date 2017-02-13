require 'sidekiq'
require 'json'

require_relative '../models/disruptions_document'
require_relative '../models/disruptions_cache'

require_relative '../config/settings'

class ParseWorker
  include Sidekiq::Worker

  def perform
    document_etag = DisruptionsDocument.get_etag(configatron.disruptions_url)

    DisruptionsCache.cache(document_etag) do 
      document = DisruptionsDocument.new(configatron.disruptions_url, configatron.disruptions_xpath)
      document.parse_coordinates
    end

    self.class.perform_in 60
  end

end
