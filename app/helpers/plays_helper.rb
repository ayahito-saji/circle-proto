module PlaysHelper
  def play_start
    # プレイ開始
    if current_room.playing? == true
      return
    end
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: false, playing: true)

    # コモン変数の初期化
    var = {
        system: {
            phase: 'title'
        }
    }
    current_room.update_attribute(:var, var)
    # 全員行動済みをfalseにする
    current_room.users.each do |user|
      user.update_attributes(actioned: false)
    end

    # プレイ開始したので、全員play画面に移行する
    RoomChannel.broadcast_to(current_room,
                             {
                                 code: "location.href = '#{root_path}';",
                                 except: [current_user.member_id]
                             })
  end
  # プレイ強制終了する時に呼び出される
  def play_end
    if current_room.playing? == false
      return
    end
    # プレイ終了
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: true, playing: false)

    # 全員行動済みをtrueにする
    current_room.users.each do |user|
      user.update_attributes(actioned: false)
    end

    # プレイ終了したので、全員room画面に移行する
    RoomChannel.broadcast_to(current_room,
                             {
                                 code: "location.href = '#{room_path}';",
                                 except: [current_user.member_id]
                             })
  end

  def get_data(data)
    puts("DATA:#{data} FROM:#{current_user.name}")
    if data['class'] == 'input'
      current_user.update_attributes(actioned: true)
        RoomChannel.broadcast_to(current_room,
                                 {
                                     code: "alert('#{current_user.name}が入力しました')"
                                 })
    end
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