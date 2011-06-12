module Relay

  def respond(response)
    # Output to the HTML response, primarily for testing purposes
    content_type 'application/json'
    response.to_json
  end

  def execute(commands)
    if commands.nil? || commands.empty?
      puts "No commands detected to execute"
    else
      commands.each do |command|
        puts "-" * 79
        pp command
        puts "-" * 79
        if command.nil? || command.empty?
          puts "Skipping this command, it's nil or empty"
        elsif command[:destination].nil? || command[:action].nil?
          puts "Skipping this command, there's no destination and/or action"
        else
          puts "Sending #{command[:action]} command to #{command[:destination]}, result:"
          object = Kernel.const_get(command[:destination])
          begin
            command[:response] = object.send command[:action], command[:args]
            pp command[:response]
          rescue Exception => e
            puts "*" * 79
            puts "An exception occurred: #{e}"
            puts "*" * 79
          end
        end
      end
    end
  end

end