module EntrancesHelper
  def enter(room)
    current_user.room_id = room.id
    if current_user.save
    else
      current_user.errors.each do |msg|
        puts(msg)
      end
    end
  end
  def enter?
    !current_user.room_id.nil?
  end
  def exit
    current_user.room_id = nil
    current_user.save
    @current_room = nil
  end
  def current_room
    @current_room ||= Room.find(current_user.room_id)
  end
end
