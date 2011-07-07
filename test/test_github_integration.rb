require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
Bundler.require(:test)
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class TestGitHubIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_payload_1_bug
    payload = File.read(File.expand_path('../examples/github/payload_1_bug.json', File.dirname(__FILE__)))
    post '/github/payload', params = {:payload => payload}
    assert last_response.ok?
  end

  def test_payload_1_bug_not_monitored
    payload = File.read(File.expand_path('../examples/github/payload_1_bug_not_monitored.json', File.dirname(__FILE__)))
    post '/github/payload', params = {:payload => payload}
    assert last_response.ok?
  end
end