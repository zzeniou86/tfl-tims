web: bundle exec rackup -p $PORT
worker: bundle exec sidekiq -r ./workers/parse_worker.rb -c 1
