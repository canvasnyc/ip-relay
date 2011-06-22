module Interpreter

  @@registered_commands = []

  def command(pattern, &block)
    @@registered_commands << {:pattern => pattern, :block => block}
  end

  def interpret(text)
    raw_commands = text.downcase.gsub(' ', '').scan /\[(.*?)\]/
    raw_commands.collect { |raw_command| route raw_command.first }
  end

  def get_args(raw_command)
    args = {}
    raw_args = raw_command.split(',')
    raw_args.each do |raw_arg|
      arg = raw_arg.split(':')
      args[arg[0].to_sym] = arg[1]
    end
    args
  end

  private

  def route(raw_command)
    @@registered_commands.each do |registered_command|
      if raw_command =~ registered_command[:pattern]
        return registered_command[:block].call raw_command
      end
    end
  end

end