post '/hoptoad/error' do
  puts "=" * 79
  puts "Hoptoad \"error\" received at #{Time.now}"
  body = request.body.read
  puts body
  error = JSON.parse body

  command = {
    :destination => 'Bugzilla',
    :action => :create_bug,
    :actionable => 'bug',
    :args => {
      :product => error["error"]["app_name"],
      :component => 'Hoptoad Errors',
      :summary => error["error"]["message"],
      :version => 'unspecified',
      :url => error["error"]["url"],
      :description => error["message"]
    }
  }

  commands = [command]
  respond execute commands
end