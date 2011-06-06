post '/beanstalk/commit' do
  puts "=" * 79
  puts "Beanstalk \"commit\" received at #{Time.now}"
  puts request.body.read
  commit = JSON.parse params[:commit]
  commands = interpret commit["message"]
  commands.each do |command|
    command[:origin] = "Beanstalk"
    command[:commit] = commit
    command[:comment] =
      "A commit has been made (r#{commit["revision"]}) by " +
      "#{commit["author_full_name"]} that references this #{command[:actionable]}.\n\n" +
      "Comment: #{commit["message"]}\n\n" +
      "Changeset URL: #{commit["changeset_url"]}"
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
        command[:origin] = "Beanstalk"
        command[:commit] = commit
        command[:comment] =
          "A commit has been made (#{commit['id'][0..7]}) by " +
          "#{commit["author"]["name"]} that references this #{command[:actionable]}.\n\n" +
          "Comment: #{commit["message"]}\n\n" +
          "Changeset URL: #{commit["url"][0..-33]}"
      end
    end
  else
    puts "*" * 79
    puts "Push is too large"
    puts "*" * 79
  end
  respond execute commands
end