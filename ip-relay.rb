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

require File.expand_path('./lib/relay.rb', File.dirname(__FILE__))
include Relay
require File.expand_path('./lib/interpreter.rb', File.dirname(__FILE__))
include Interpreter

# Origins
require File.expand_path('./lib/origins/beanstalk.rb', File.dirname(__FILE__))
require File.expand_path('./lib/origins/hoptoad.rb', File.dirname(__FILE__))
require File.expand_path('./lib/origins/deployment.rb', File.dirname(__FILE__))

# Destinations
require File.expand_path('./lib/destinations/bugzilla.rb', File.dirname(__FILE__))
require File.expand_path('./lib/destinations/intervals.rb', File.dirname(__FILE__))
require File.expand_path('./lib/destinations/campfire.rb', File.dirname(__FILE__))
require File.expand_path('./lib/destinations/email.rb', File.dirname(__FILE__))

if settings.basic_auth
  use Rack::Auth::Basic, "iP Relay" do |username, password|
    settings.basic_auth_credentials.include? [username, password]
  end
end

get '/debug' do
  erb :debug
end

get '/log/:lines' do
  `tail -n #{params[:lines]} log/ip-relay.log`
end