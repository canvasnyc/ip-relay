command /bug.*status/ do |raw_command|
  args = get_args raw_command
  command = {
    :destination => 'Bugzilla',
    :action => :update_bug,
    :args => {
      :ids => args[:bug],
      :comment => nil,
      :status => args[:status].upcase,
      :resolution => 'FIXED'
    }
  }
end

command /bug/ do |raw_command|
  args = get_args raw_command
  command = {
    :destination => 'Bugzilla',
    :action => :add_comment,
    :actionable => 'bug',
    :args => {
      :id => args[:bug],
      :comment => nil,
    }
  }
end

class Bugzilla

  def self.add_comment(args)
    self.call "Bug.add_comment", args
  end

  def self.update_bug(args)
    args[:comment] = {:body => args[:comment]}
    self.call "Bug.update", args
  end

  def self.create_bug(args)
    self.call "Bug.create", args
  end

  def self.search(args)
    self.call "Bug.search", args
  end

  private

  def self.auth_args
    {:Bugzilla_login => settings.bugzilla[:login], :Bugzilla_password => settings.bugzilla[:password]}
  end

  def self.call(command, args)
    server = XMLRPC::Client.new2 settings.bugzilla[:url]
    server.call command, args.merge(self.auth_args)
  end

end