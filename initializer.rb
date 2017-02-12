require 'sidekiq'
require 'sidekiq/api'
require './workers/parse_worker'

# on startup we want to delete existing jobs
# and then queue just one 

Sidekiq::Queue.new.each do |job|
  job.delete
end

ParseWorker.perform_async