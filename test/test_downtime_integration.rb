require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
Bundler.require(:test)
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class TestHoptoadIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_alert
    alert = File.read(File.expand_path('../examples/downtime/alert.json', File.dirname(__FILE__)))
    post '/downtime', params = {:alert => alert}
    assert last_response.ok?
  end

end