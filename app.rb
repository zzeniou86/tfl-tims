$stdout.sync = true

require 'sinatra/base'
require 'sidekiq'
require 'redis'
require 'sidekiq/api'


class Quiqup < Sinatra::Base
  get "/" do
      erb :index
  end
end