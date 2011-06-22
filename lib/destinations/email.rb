command /email/ do |raw_command|
  args = get_args raw_command
  command = {
    :destination => 'Email',
    :action => :email,
    :args => {
      :to => args[:email],
      :comment => nil,
    }
  }
end

class Email

  def self.email(args)
    result = Pony.mail(
      :from => settings.smtp[:username],
      :to => args[:to],
      :subject => args[:comment],
      :body => args[:comment],
      :via => :smtp,
      :via_options => {
        :address => settings.smtp[:host],
        :port => settings.smtp[:port],
        :user_name => settings.smtp[:username],
        :password => settings.smtp[:password],
        :authentication => settings.smtp[:authentication],
        :domain => settings.smtp[:domain],
        :enable_starttls_auto => false
      }
    )
    return result.inspect
  end

end