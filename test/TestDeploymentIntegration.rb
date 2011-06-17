require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
Bundler.require(:test)
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class TestHoptoadIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_notification
    notification = File.read(File.expand_path('../examples/deployment/notification.json', File.dirname(__FILE__)))
    post '/deployment', params = {:notification => notification}
    assert last_response.ok?
  end

end