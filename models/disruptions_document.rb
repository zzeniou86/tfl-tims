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

end