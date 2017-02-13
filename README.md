# TFL TIMS Feed

**(Please read [NOTES.md](NOTES.md) for thoughts, comments and approach)**

A simple sinatra app that consumes the XML feed and shows on a Google Maps the locations of the disruptions.

## Prerequistes

*   Have [Ruby](https://www.ruby-lang.org) 2.0 or above installed (the program was written and tested in ruby 2.4.0p0)

*   Have [Bundler](http://bundler.io/) installed (i.e. `gem install bundle`)

*   Have [Redis](https://redis.io/) installed (i.e. `brew install redis`)

*   Optional: Have [Foreman](http://ddollar.github.io/foreman/) installed. It manages Procfile apps. (i.e. `gem install foreman`)

## Installation & Setup

Execute:

    $ bundle install

which will install all gem dependencies for the program. Then execute:

    $ redis-server

which will start the redis-server if it's not aready setup for autorun

Set `ENV["MAPS_KEY"]` environment variable or edit `config/settings.rb` with a GoogleMaps API KEY.  

*Optional*: If TIMS URL or XML STRUCTURE changes, please set `ENV["DISRUPTIONS_URL"]` or and `ENV["DISRUPTIONS_URL"]`. Alternatively edit `config/settings.rb`

## Usage

If you use `foreman`, run the app with the following command:

`foreman start`

Which will run both app and sidekiq.

Alternatively: run these commands in two separate terminal windows:
    
    $ bundle exec rackup -p 5000 
    $ bundle exec sidekiq -r ./workers/parse_worker.rb -c 1`

Navigate to `http://localhost:5000/`

![Screenshot](/screenshot.png)


## Testing

Run `bundle exec rake test` to run the tests


## TODO

*   Provide API endpoint (to serve JSON)
*   Write a better index.html
*   Google Maps: Fetch new coordinates every couple seconds to add real-time updates.
*   Catch errors and handle them
*   Use XML::SAX::Parser instead of XPATH for optimized parsing
*   Use stubs and mocks for DisruptionsDocument.new and DisruptionsCache.fetch and .DisruptionsCache
*   Write tests for DisruptionCache, DisruptionDocument and ParseWorker.

## License

[MIT License](http://opensource.org/licenses/MIT)
