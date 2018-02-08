module PlaysHelper
  def play_start
    # プレイ開始
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: false, playing: true)

    # コモン変数の初期化
    current_room.update_attribute(:var, '')

    # ゲーム開始を通知
    RoomChannel.broadcast_to(current_user.room_id, body: {class: "redirect", to: root_path}, from: current_user.name)

    #
  end
  def play_end
    # プレイ終了
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: true, playing: false)

    # ゲーム終了を通知
    RoomChannel.broadcast_to(current_user.room_id, body: {class: "redirect", to: room_path}, from: current_user.name)
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

  def get_data(data, action_cable)
    puts("DATA:#{data}")
  end
  def post_data(data)
    RoomChannel.broadcast_to(current_user.room_id, body: data, from: current_user.name)
  end
end
