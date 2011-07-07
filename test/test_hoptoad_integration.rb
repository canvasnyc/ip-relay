require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
Bundler.require(:test)
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class TestHoptoadIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_error
    error = File.read(File.expand_path('../examples/hoptoad/error.json', File.dirname(__FILE__)))
    post '/hoptoad/error', params = error
    assert last_response.ok?
  end

  def test_error_too_long
    error = File.read(File.expand_path('../examples/hoptoad/error_too_long.json', File.dirname(__FILE__)))
    post '/hoptoad/error', params = error
    assert last_response.ok?
  end

end