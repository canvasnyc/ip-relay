require 'tinder'

create_destination :chat, 'Campfire'

class Campfire

  def self.execute(command)
    @@campfire = Tinder::Campfire.new settings.campfire[:subdomain], :token => settings.campfire[:token]
    room = @@campfire.find_room_by_name command[:chat].capitalize
    room.speak command[:comment]
  end

end