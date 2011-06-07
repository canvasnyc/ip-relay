require 'rubygems'
require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class TestHoptoadIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_error
    error = File.read(File.expand_path('../examples/hoptoad.json', File.dirname(__FILE__)))
    post '/hoptoad/error', params = error
    assert last_response.ok?
  end

end