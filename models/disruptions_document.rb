require 'nokogiri'
require 'open-uri'

class DisruptionsDocument

  def initialize(url)
    @disruptions = Nokogiri::XML(open(url))
  end

  def parse_coordinates
    @disruptions.xpath("//xmlns:Disruptions/xmlns:Disruption/xmlns:CauseArea/xmlns:DisplayPoint/xmlns:Point/xmlns:coordinatesLL").map do |node|
      lng, lat = node.text.split(",")
      {lat: lat.to_f, lng: lng.to_f}
    end
  end

  def self.get_etag(url)
    uri_url = URI(url)
    etag = nil
    Net::HTTP.start(uri_url.host, uri_url.port, use_ssl: true) do |http|
      response = http.head(uri_url.path)
      etag = response["etag"]
    end
    etag
  end

end
