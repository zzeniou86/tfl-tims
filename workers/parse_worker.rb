require 'sidekiq'
require 'json'

require_relative '../models/disruptions_document'
require_relative '../models/disruptions_cache'

require_relative '../config/settings'

class ParseWorker
  include Sidekiq::Worker
  
  # Get Etag (via HEAD request) and compare with cached etag.
  # If not matched, parse document and cache etag + results (historically)
  # Finally, re-queue the job itself  
  
  def perform
    document_etag = DisruptionsDocument.get_etag(configatron.disruptions_url)

    DisruptionsCache.cache(document_etag) do 
      document = DisruptionsDocument.new(configatron.disruptions_url, configatron.disruptions_xpath)
      document.parse_coordinates
    end

    self.class.perform_in 60
  end

end
