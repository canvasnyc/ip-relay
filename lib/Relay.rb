module Relay

  @@destinations = {}

  def create_destination(key, class_name)
    @@destinations[key] = class_name
  end

  def respond(response)
    # Output to STDOUT, and thereby the log
    pp response
    # Output to the HTML response, primarily for testing purposes
    content_type 'text/json'
    response.to_json
  end

  def interpret(message)
    between_brackets = message.gsub(' ', '').scan /\[(.*?)\]/
    commands = between_brackets.collect do |text|
      params = text.first.split(',')
      command = {}
      params.each do |text|
        param = text.split(':')
        key = param[0].to_sym; value = param[1]
        command[key] = value
        command[:destination] = @@destinations[key] if @@destinations.include? key
      end
      command
    end
  end

  def execute(commands)
    commands.each do |command|
      Kernel.const_get(command[:destination]).send :execute, command unless command[:destination].nil?
    end
  end

end