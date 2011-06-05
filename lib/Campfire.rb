require 'tinder'

create_destination :chat, 'Campfire'

class Campfire

  def initialize
    @campfire = Tinder::Campfire.new settings.campfire[:subdomain], :token => settings.campfire[:token]
  end

  def execute(command)
    room = @campfire.find_room_by_name command[:chat].capitalize
    room.speak command[:comment]
  end

end