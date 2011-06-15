command /task/ do |raw_command|
  args = get_args raw_command
  command = {
    :destination => 'Intervals',
    :action => :add_comment,
    :args => {
      :id => args[:task],
      :comment => nil,
    }
  }
end

class Intervals

  include HTTParty
  base_uri settings.intervals[:url]
  basic_auth settings.intervals[:username], settings.intervals[:password]
  headers "Content-Type" => "application/json", "Accept" => "application/json", "X-Intervals-Send-Notifications" => "t"

  def self.add_comment(args)
    taskid = self.task(args[:id]).parsed_response['task'].first['id']
    self.tasknote taskid, args[:comment]
  end

  private

  def self.task(localid)
    get '/task/', :query => {:localid => localid}
  end

  def self.tasknote(taskid, note)
    post '/tasknote/', :body => {:taskid => taskid, :note => note, :public => 'f'}.to_json
  end

end