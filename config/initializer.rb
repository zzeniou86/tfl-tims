require 'sidekiq'
require 'sidekiq/api'
require './workers/parse_worker'

# SIDEKIQ

# On app startup we want to clear the queue of any existing job since we only need one
# and then we queue just one job

Sidekiq::Queue.new.each do |job|
  job.delete
end

ParseWorker.perform_async

# TODO: Add REDIS  configuration setup in case its not default.
