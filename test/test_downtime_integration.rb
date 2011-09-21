require File.expand_path('../ip-relay.rb', File.dirname(__FILE__))
Bundler.require(:test)
require 'test/unit'

ENV['RACK_ENV'] = 'test'

class TestDowntimeIntegration < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    puts "Resetting logged alerts..."
    file = File.join(settings.db_path, 'downtime.db')
    File.delete(file) if File.exists?(file)
  end

  def test_1_alert
    alert = File.read(File.expand_path('../examples/downtime/alert.json', File.dirname(__FILE__)))
    post '/downtime', params = {:alert => alert}
    assert last_response.ok?
  end

  def test_2_alerts
    alert = File.read(File.expand_path('../examples/downtime/alert.json', File.dirname(__FILE__)))
    2.times {
      post '/downtime', params = {:alert => alert}
      assert last_response.ok?
    }
  end
end