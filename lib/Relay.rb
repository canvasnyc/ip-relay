module Relay

  @@destinations = {}

  def create_destination(key, object)
    @@destinations[key] = object
  end

  def respond(response)
    # Output to the HTML response, primarily for testing purposes
    content_type 'application/json'
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
        if @@destinations.include? key
          command[:actionable] = key
          command[:destination] = @@destinations[key]
        end
      end
      command
    end
  end

  def execute(commands)
    if commands.nil? || commands.empty?
      puts "No commands detected to execute"
    else
      commands.each do |command|
        puts "-" * 79
        if command.empty?
          puts "Skipping this command, it's empty"
        elsif command[:destination].nil?
          puts "Skipping this command, there's no destination"
        else
          puts "Sending command to: #{command[:destination]}"
          object = Kernel.const_get(command[:destination])
          begin
            command[:response] = object.send :execute, command
          rescue Exception => e
            puts "*" * 79
            puts "An exception occurred: #{e}"
            puts "*" * 79
          end
        pp command
        end
      end
    end
  end

end