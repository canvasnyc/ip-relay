post '/downtime' do
  puts "=" * 79
  puts "Downtime alert received at #{Time.now}"
  puts request.body.read
  alert = JSON.parse params[:alert]
  commands = interpret alert["commands"]
  commands.each do |command|
    command[:origin] = {
      :name => "Downtime",
      :alert => alert
    }
    command[:args][:comment] =
      "#{alert['site']} #{alert['environment']} at #{alert['url']} is down: #{alert['message']}"
  end
  respond execute commands
end