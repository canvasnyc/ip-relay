Dir.chdir '../'
require 'rubygems'
require 'sinatra'
require 'ip-relay'
require 'json'
require 'test/unit'
require 'rack/test'

ENV['RACK_ENV'] = 'test'

class TestHoptoadIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_error
    error = File.read('examples/hoptoad.json')
    post '/hoptoad/error', params = error
    assert last_response.ok?
  end

end