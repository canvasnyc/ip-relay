create_destination :task, 'Intervals'

class Intervals

  include HTTParty
  base_uri settings.intervals[:url]
  basic_auth settings.intervals[:username], settings.intervals[:password]
  headers "Content-Type" => "application/json", "Accept" => "application/json", "X-Intervals-Send-Notifications" => "t"

  def self.execute(command)
    add_comment command[:task], command[:comment]
  end

  def self.task(localid)
    get '/task/', :query => {:localid => localid}
  end

  def self.tasknote(taskid, note)
    post '/tasknote/', :body => {:taskid => taskid, :note => note, :public => 'f'}.to_json
  end

  def self.add_comment(id, comment)
    taskid = task(id).parsed_response['task'].first['id']
    tasknote taskid, comment
  end

end