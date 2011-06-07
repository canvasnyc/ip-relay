post '/hoptoad/error' do
  puts "=" * 79
  puts "Hoptoad \"error\" received at #{Time.now}"
  body = request.body.read
  puts body
  error = JSON.parse body
  command = {
    :destination => 'Bugzilla',
    :status => 'NEW',
    :product => error["error"]["app_name"],
    :component => 'Hoptoad Errors',
    :summary => error["error"]["message"],
    :version => 'unspecified'
  }
  command[:optional_args] = {
    :url => error["error"]["url"],
    :description => error["message"]
  }
  commands = [command]
  respond execute commands
end