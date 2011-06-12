require "rubygems"
require "pp"
require "xmlrpc/client"
require "bundler/setup"
Bundler.require

# start logging after third-party dependencies are loaded
# but before lib dependencies so that we can catch application
# errors in production
if settings.logging_to_disk
  log = File.new(File.expand_path('./log/ip-relay.log', File.dirname(__FILE__)), "a")
  STDOUT.reopen(log)
  STDERR.reopen(log)
end

require File.expand_path('./lib/Relay.rb', File.dirname(__FILE__))
include Relay
require File.expand_path('./lib/Interpreter.rb', File.dirname(__FILE__))
include Interpreter

# Origins
require File.expand_path('./lib/Beanstalk.rb', File.dirname(__FILE__))
require File.expand_path('./lib/Hoptoad.rb', File.dirname(__FILE__))

# Destinations
require File.expand_path('./lib/Bugzilla.rb', File.dirname(__FILE__))
require File.expand_path('./lib/Intervals.rb', File.dirname(__FILE__))
require File.expand_path('./lib/Campfire.rb', File.dirname(__FILE__))

if settings.basic_auth
  use Rack::Auth::Basic, "iP Relay" do |username, password|
    [username, password] == settings.basic_auth_credentials
  end
end

get '/debug' do
  erb :debug
end

get '/log/:lines' do
  `tail -n #{params[:lines]} log/ip-relay.log`
end