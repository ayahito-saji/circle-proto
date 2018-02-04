module EntrancesHelper
  def remember_room_token(room_token)
    session[:room_token] = room_token
  end
  def remember_room_token?
    !session[:room_token].nil?
  end
  def current_room_token
    session[:room_token]
  end
  def forget_room_token
    session.delete(:room_token)
  end

  def enter(room)
    if enter?
      exit
    end
    if room.users.count < room.maximum || room.maximum == -1
      current_user.update_attribute(:room_id, room.id)
      true
    else
      false
    end
  end
  def enter?
    if !current_room.nil?
      true
    else
      exit if !current_user.room_id.nil?
      false
    end
  end
  def exit
    exit_room = current_room
    current_user.update_attribute(:room_id, nil)
    if !exit_room.nil? && exit_room.users.count == 0
      exit_room.destroy
    end
    @current_room = nil
  end
  def current_room
    @current_room ||= Room.find_by(id: current_user.room_id)
  end
  def require_enter
    until enter?
      redirect_to account_path
      return
    end
  end
  def reject_enter
    if enter?
      redirect_to root_path
      return
    end
  end
end
