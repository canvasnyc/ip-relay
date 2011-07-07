post '/github/payload' do
  puts "=" * 79
  puts "GitHub \"payload\" received at #{Time.now}"
  puts request.body.read
  payload = JSON.parse params[:payload]
  commands = []
  if !settings.github[:branches_monitored].include? GitHub.branch(payload)
    puts "*" * 79
    puts "Branch #{GitHub.branch(payload)} is not monitored"
    puts "*" * 79
  else
    payload["commits"].each do |commit|
      commands += interpret(commit["message"]).each do |command|
        command[:origin] = {
          :name => "GitHub",
          :commit => commit
        }
        command[:args][:comment] =
          "#{commit["author"]["name"]} committed #{commit['id'][0..6]} " +
          "to #{payload["repository"]["name"]}:\n\n" +
          "\"#{GitHub.shorten_message commit["message"]}\"\n\n" +
          "#{commit["url"][0..-34]}"
      end
    end
  end
  respond execute commands
end

module GitHub
  def self.shorten_message(message)
    message.match(/(.*?)\[/).captures.first.rstrip
  end

  def self.branch(payload)
    payload["ref"].match(/refs\/heads\/(.*)/).captures.first
  end
end