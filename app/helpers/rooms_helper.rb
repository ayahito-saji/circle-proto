module RoomsHelper
  def login(room_id, user_id)
    session[:room_id] = room_id
    session[:user_id] = user_id
  end
  def login?
    session[:room_id] && session[:session_id]
  end
  def logout
    session[:room_id] = nil
    session[:user_id] = nil
  end
  def current_room
    @current_room ||= Room.find(session[:room_id])
  end
  def current_user
    @current_user ||= User.find(session[:user_id])
  end
end
