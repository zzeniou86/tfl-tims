require 'nokogiri'
require 'open-uri'

# TODO: Refactor class to use XML::SAX::Parser for optimized parsing. http://www.rubydoc.info/gems/nokogiri/Nokogiri/XML/SAX/Parser

class DisruptionsDocument

  def initialize(url, xpath)
    @disruptions = Nokogiri::XML(open(url))
    @xpath = xpath
  end

  # Using XPATH, find the coordinates and construct the output array
  # (Change XPATH string in config/settings.rb)
  def parse_coordinates
    @disruptions.xpath(@xpath).map do |node|
      lng, lat = node.text.split(",")
      {lat: lat.to_f, lng: lng.to_f}
    end
  end

  # HEAD request to get the etag.
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
