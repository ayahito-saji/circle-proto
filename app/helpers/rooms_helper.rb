module RoomsHelper
  # ルーム全員にブロードキャストする(except: []で例外を指定できる)
  def broadcast_to_room(room, data, **option)
    room.users.each do |user|
      if !option[:except] || !option[:except].include?(user)
        UserChannel.broadcast_to(user, data)
      end
    end
  end
end
