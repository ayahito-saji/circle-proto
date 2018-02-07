module PlaysHelper
  def play_start
    current_room.skip_search_validation = true
    current_room.update_attributes(var: "", allow_enter: false, playing: true)
  end
  def play_end
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: true, playing: false)
  end

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
