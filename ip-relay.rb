require 'pp'
require 'json'
require 'sinatra/config'

require 'lib/Relay'; include Relay

# Origins
require 'lib/Beanstalk'

# Destinations
require 'lib/Bugzilla'



if settings.basic_auth
  use Rack::Auth::Basic, "iP Relay" do |username, password|
    [username, password] == settings.basic_auth_credentials
  end
end

get '/debug' do
  erb :debug
end