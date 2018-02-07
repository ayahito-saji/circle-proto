module PlaysHelper
  def require_playing
    redirect_to room_path
    return
  end
end
