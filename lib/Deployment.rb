post '/deployment' do
  puts "=" * 79
  puts "Deployment notification received at #{Time.now}"
  puts request.body.read
  notification = JSON.parse params[:notification]
  commands = interpret notification["commands"]
  commands.each do |command|
    command[:origin] = {
      :name => "Deployment",
      :notification => notification
    }
    command[:args][:comment] =
      "#{notification["name"]} deployed #{notification["branch"]} " +
      "(#{notification["commit"][0..6]}) to " +
      "#{notification["application"]} #{notification["environment"]}"
  end
  respond execute commands
end