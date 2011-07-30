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
      "#{commit["author_full_name"]} committed r#{commit["revision"]}:\n\n" +
      "\"#{SCM.strip_commands commit["message"]}\"\n\n" +
      "#{commit["changeset_url"]}"
  end
  respond execute commands
end

post '/beanstalk/payload' do
  puts "=" * 79
  puts "Beanstalk \"payload\" received at #{Time.now}"
  puts request.body.read
  payload = JSON.parse params[:payload]
  commands = []
  if payload["push_is_too_large"]
    puts "*" * 79
    puts "Push is too large"
    puts "*" * 79
  else
    scm = SCM.new 'beanstalk'
    payload["commits"].each do |commit|
      unless scm.is_logged? commit
        commands += interpret(commit["message"]).each do |command|
          command[:origin] = {
            :name => "Beanstalk",
            :commit => commit
          }
          command[:args][:comment] =
            "#{commit["author"]["name"]} committed #{commit['id'][0..7]} " +
            "to #{payload["repository"]["name"]}:\n\n" +
            "\"#{SCM.strip_commands commit["message"]}\"\n\n" +
            "#{commit["url"]}"
        end
      end
    end
  end
  respond execute commands
end