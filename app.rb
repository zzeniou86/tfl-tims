$stdout.sync = true

require 'sinatra/base'
require 'redis'
require 'json'

require './models/disruptions_document'

$redis ||= Redis.new

class Quiqup < Sinatra::Base
  get "/" do
    @list = $redis.get "coords"
    @list = JSON.parse(@list)
    erb :index
  end
end
