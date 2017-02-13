# Notes

## Why Sinatra and not Rails?

Rails comes with batteries included and almost everything is out of the box, (even cache with `Rails.cache.fetch`). While that's great, the TIMS application is very simple and it does not needs the boilerplate and the extra middleware.

With Sinatra, I can use exactly what I need, while demonstrating my capabilities of creating a rackup app/service from scratch. This keep the application quite simple, fast and easy to reason.

The drawback of this approach is that some extra code is required to do things

Another drawback is that, for an example, Rails.cache is well tested and documented and implementing a similar solution from scratch isn't the best idea for production app. I'll be better off to use a well tested Gem.

Nevertheless, for the purposes of the code, Sinatra is a good choice.

## Why use Sidekiq?

While I could stop at a solution like the following:

```ruby
  get "/" do
    @list = Cache.fetch("coords", 60) do
      document = DisruptionsDocument.new(url)
      document.parse_coordinates
    end
    erb :index
  end
```

Realistically the web application should be responsible for fetching and displaying the data, and the background jobs / services should be responsible for data parsing and processing.

This approach works very well in microservices (or distributed systems in that sense).

For an example, we could rewrite the background job in Elixir for all that matters.

As a fallback though, the abov code example exists in app.rb, in case the background jobs fails or if one wishes to run the app without background jobs.

## Where are the tests?

The codebase has a simple test suit but it's missing some quite important tests that requires stubs and mocks. Unfortunately I ran out of time to implement the bare minimum tests required for this app. This would definitely not be a case for a production app.

## Why not TDD ?

I approached this code test in "explorative manner", meaning that I needed to see what works (and does not work) in order to opt for a solution. Because of that approach it was difficult to have a TDD approach (where as in most CLI apps for an example, it's easy to TDD/BDD when inputs/outputs are well defined)