require 'configatron'

# DISRUPTIONS DOCUMENT
configatron.disruptions_url = ENV["DISRUPTIONS_URL"] || 'https://data.tfl.gov.uk/tfl/syndication/feeds/tims_feed.xml'
configatron.disruptions_xpath = ENV["DISRUPTIONS_XPATH"] || '//xmlns:Disruptions/xmlns:Disruption/xmlns:CauseArea/xmlns:DisplayPoint/xmlns:Point/xmlns:coordinatesLL'

# MAPS API
configatron.google_maps_key = ENV["MAPS_KEY"] || 'AIzaSyCiTWf2oWxATT6NLfCPWj6FJGTWfHE8NIA'