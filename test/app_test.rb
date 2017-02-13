require_relative './test_helper'

class AppTest < MiniTest::Test

  include Rack::Test::Methods

  def app
    Quiqup
  end

  #TODO: add stubs for DisruptionCache.cache  http://www.rubydoc.info/gems/minitest/4.2.0/Object:stub
  #TODO: add HTTP mock (using webmock)
  def test_app
    get '/'
    assert last_response.ok?
    assert_equal 200, last_response.status
  end
end
