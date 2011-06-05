require 'xmlrpc/client'

create_destination :bug, 'Bugzilla'

class Bugzilla

  def self.execute(command)
    @@server = XMLRPC::Client.new2 settings.bugzilla[:url]
    if command[:status].nil?
      add_comment command[:bug], command[:comment]
    else
      update_bug command[:bug], command[:comment], command[:status]
    end
  end

  def self.auth_args
    {
    :Bugzilla_login => settings.bugzilla[:login],
    :Bugzilla_password => settings.bugzilla[:password]
    }
  end

  def self.add_comment(id, comment)
    args = {:id => id, :comment => comment}
    @@server.call "Bug.add_comment", args.merge(auth_args)
  end

  def self.update_bug(id, comment, status)
    args = {
      :ids => id,
      :comment => {:body => comment},
      :status => status.upcase,
      :resolution => 'FIXED'
    }
    @@server.call "Bug.update", args.merge(auth_args)
  end

end