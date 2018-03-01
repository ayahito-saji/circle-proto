module PlaysHelper
  def require_playing
    unless current_room.playing?
      redirect_to room_path
      return
    end
  end

  def reject_playing
    if current_room.playing?
      redirect_to root_path
      return
    end
  end
end