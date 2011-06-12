post '/beanstalk/commit' do
  puts "=" * 79
  puts "Beanstalk \"commit\" received at #{Time.now}"
  puts request.body.read
  commit = JSON.parse params[:commit]
  commands = interpret commit["message"]
  commands.each do |command|
    command[:origin] = {
      :name => "Beanstalk",
      :commit => commit
    }
    command[:args][:comment] =
      "#{commit["author_full_name"]} made a commit (r#{commit["revision"]}) " +
      "that mentioned this #{command[:actionable]}.\n\n" +
      "#{commit["message"]}\n\n#{commit["changeset_url"]}"
  end
  respond execute commands
end

post '/beanstalk/payload' do
  puts "=" * 79
  puts "Beanstalk \"payload\" received at #{Time.now}"
  puts request.body.read
  payload = JSON.parse params[:payload]
  commands = []
  unless payload["push_is_too_large"]
    payload["commits"].each do |commit|
      commands += interpret(commit["message"]).each do |command|
        command[:origin] = {
          :name => "Beanstalk",
          :commit => commit
        }
        command[:args][:comment] =
          "#{commit["author"]["name"]} made a commit (#{commit['id'][0..7]}) " +
          "to #{payload["repository"]["name"]} that mentioned this #{command[:actionable]}.\n\n" +
          "#{commit["message"]}\n\n#{commit["url"]}"
      end
    end
  else
    puts "*" * 79
    puts "Push is too large"
    puts "*" * 79
  end
  respond execute commands
end