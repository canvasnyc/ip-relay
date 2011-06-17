require 'rubygems'
require 'json'
require 'httparty'
require 'pp'

class IPRelay

  include HTTParty
  headers "HTTP_CONTENT_TYPE" => "application/json", "HTTP_ACCEPT" => "application/json"

  def self.config(config)
    @@config = config
    base_uri @@config[:url]
    basic_auth(@@config[:username], @@config[:password]) if @@config[:basic_auth]
  end

  def self.notify(cap_vars)
    notification = {
      "name" => @@config[:name],
      "branch" => cap_vars.revision,
      "commit" => cap_vars.real_revision,
      "application" => cap_vars.application,
      "environment" => cap_vars.rails_env,
      "commands" => @@config[:commands]
    }

    puts "Sending deployment notification via iP Relay:"
    pp notification

    post '/deployment', :body => {:notification => notification.to_json}
  end

end