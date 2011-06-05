require 'rubygems'
require 'sinatra'
require 'sinatra/config'
require 'pp'
require 'json'

require 'lib/Relay'; include Relay

# Origins
require 'lib/Beanstalk'

# Destinations
require 'lib/Bugzilla'
require 'lib/Intervals'
require 'lib/Campfire'

if settings.basic_auth
  use Rack::Auth::Basic, "iP Relay" do |username, password|
    [username, password] == settings.basic_auth_credentials
  end
end

get '/debug' do
  erb :debug
end