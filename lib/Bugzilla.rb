require 'xmlrpc/client'

create_destination :bug, 'Bugzilla'

class Bugzilla

  def self.execute(command)
    @@server = XMLRPC::Client.new2 settings.bugzilla[:url]
    if command[:status].nil?
      add_comment command[:bug], command[:comment]
    elsif command[:status].upcase == "NEW"
      create_bug command[:product], command[:component], command[:summary], command[:version], command[:optional_args]
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

  def self.update_bug(id, comment, status, resolution = 'FIXED')
    args = {
      :ids => id,
      :comment => {:body => comment},
      :status => status.upcase,
      :resolution => resolution.upcase
    }
    @@server.call "Bug.update", args.merge(auth_args)
  end

  def self.create_bug(product, component, summary, version, optional_args = nil)
    args = {
      :product => product,
      :component => component,
      :summary => summary,
      :version => version
    }
    args.merge! optional_args unless optional_args.nil?
    @@server.call "Bug.create", args.merge(auth_args)
  end

end