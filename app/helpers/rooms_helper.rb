module RoomsHelper
  def login(room_id, user_id)
    session[:room_id] = room_id
    session[:user_id] = user_id
  end
  def login?
    session[:room_id] && session[:session_id]
  end
  def logout
    session.delete(:room_id)
    session.delete(:user_id)
    @current_room = nil
    @current_user = nil
  end
  def current_room
    @current_room ||= Room.find(session[:room_id])
  end
  def current_user
    @current_user ||= User.find(session[:user_id])
  end
end
