require 'pp'
require 'json'
require 'sinatra/config'

require 'lib/Beanstalk'

if settings.basic_auth
  use Rack::Auth::Basic, "iP Relay" do |username, password|
    [username, password] == settings.basic_auth_credentials
  end
end

def respond(response)
  # Output to STDOUT, and thereby the log
  pp response
  # Output to the HTML response, primarily for testing purposes
  content_type 'text/json'
  response.to_json
end

def interpret(message)
  message.gsub! ' ', ''
  commands = message.scan /\[(.*?)\]/
  commands.collect do |command|
    params = command.first.split(',')
    command = {}
    params.each do |param|
      param = param.split(':')
      command.merge! param[0].to_sym => param[1]
    end
    command
  end
end

get '/debug' do
  erb :debug
end