post '/hoptoad/error' do
  puts "=" * 79
  puts "Hoptoad \"error\" received at #{Time.now}"
  body = request.body.read
  puts body
  error = JSON.parse body
  error["id"] = error["error"]["url"].match(/(\d*)$/).captures.first
  response = Hoptoad.search error
  bugs = response.first[:response]["bugs"]
  if bugs.empty?
    response << Hoptoad.create_bug(error)
  else
    bug = bugs.first
    if bug["resolution"] == 'FIXED'
      response << Hoptoad.update_bug(error, bug["id"])
    else
      response << Hoptoad.add_comment(error, bug["id"])
    end
  end
  respond response
end

class Hoptoad

  def self.search(error)
    command = {
      :destination => 'Bugzilla',
      :action => :search,
      :args => {
        :summary => "[Hoptoad ID: #{error["id"]}]",
        :limit => 1
      }
    }
    execute command
  end

  def self.create_bug(error)
    command = {
      :destination => 'Bugzilla',
      :action => :create_bug,
      :args => {
        :product => error["error"]["app_name"],
        :component => 'Hoptoad Errors',
        :summary => "#{error["error"]["message"]} [Hoptoad ID: #{error["id"]}]",
        :version => 'unspecified',
        :url => error["error"]["url"],
        :description => error["message"]
      }
    }
    execute command
  end

  def self.add_comment(error, id)
    command = {
      :destination => 'Bugzilla',
      :action => :add_comment,
      :args => {
        :id => id,
        :comment => error["message"]
      }
    }
    execute command
  end

  def self.update_bug(error, id)
    command = {
      :destination => 'Bugzilla',
      :action => :update_bug,
      :args => {
        :ids => id,
        :comment => error["message"],
        :status => 'REOPENED'
      }
    }
    execute command
  end

end