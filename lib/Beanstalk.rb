post '/beanstalk/commit' do
  commit = JSON.parse params[:commit]
  commands = interpret commit["message"]
  commands.each do |command|
    command[:origin] = "Beanstalk"
    command[:commit] = commit
    command[:comment] =
      "A commit has been made (r#{commit["revision"]}) by " +
      "#{commit["author_full_name"]} that references this bug.\n\n" +
      "Comment: #{commit["message"]}\n\n" +
      "Changeset URL: #{commit["changeset_url"]}"
  end
  respond execute commands
end

post '/beanstalk/payload' do
  payload = JSON.parse params[:payload]
  commands = []
  unless payload["push_is_too_large"]
    payload["commits"].first.each do |id, commit|
      commands += interpret(commit["message"]).each do |command|
        command[:origin] = "Beanstalk"
        command[:commit] = commit
        command[:comment] =
          "A commit has been made (#{commit['id'][0..7]}) by " +
          "#{commit["author"]["name"]} that references this bug.\n\n" +
          "Comment: #{commit["message"]}\n\n" +
          "Changeset URL: #{commit["url"][0..-33]}"
      end
    end
  end
  respond execute commands
end

class Beanstalk
end