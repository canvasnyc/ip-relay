command /chat/ do |raw_command|
  args = get_args raw_command
  command = {
    :destination => 'Campfire',
    :action => :speak,
    :actionable => 'chat',
    :args => {
      :room => args[:chat].capitalize,
      :comment => nil,
    }
  }
end

class Campfire

  def self.speak(args)
    room = self.campfire.find_room_by_name args[:room]
    room.speak args[:comment]
  end

  private

  def self.campfire
    Tinder::Campfire.new settings.campfire[:subdomain], :token => settings.campfire[:token]
  end

end