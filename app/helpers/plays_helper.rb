module PlaysHelper
  def play_start
    # プレイ開始
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: false, playing: true)

    # コモン変数の初期化
    var = {
        system: {
            status: 'title'
        }
    }
    current_room.update_attribute(:var, var)
    # 全員行動済みをfalseにする
    current_room.users.each do |user|
      user.update_attribute(:actioned, false)
    end

    # プレイ開始したので、全員play画面に移行する
    RoomChannel.broadcast_to(current_user.room_id, body: {class: "redirect", to: root_path}, from: current_user.name)
  end
  # プレイ強制終了する時に呼び出される
  def play_end
    # プレイ終了
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: true, playing: false)

    # プレイ終了したので、全員room画面に移行する
    RoomChannel.broadcast_to(current_user.room_id, body: {class: "redirect", to: room_path}, from: current_user.name)
  end

  def play_view # プレイ開始時または再読み込み、再アクセスした際に呼び出される
    puts(current_room.var)
    html_code = ""
    cmn_var = current_room.var

    if cmn_var[:system][:status] == 'title'
      html_code = "<h1>人狼ゲームはっじまるよー</h1>"
      if !current_user.actioned?
        html_code += "<p><a href=\"javascript:post_data({'result': 'success'}),$('#link').hide()\" id='link'>Start</a></p>"
      end
    end

    #表示するHTMLコードを返す
    html_code.html_safe
  end
  def get_data(data, action_cable) # プレイ時にActionCable及びpostでデータを受け取った時に呼び出される
    cmn_var = current_room.var
    puts("DATA:#{data} ACTION_CABLE:#{action_cable}")


    if cmn_var[:system][:status] == 'title'
      if data['result'] == 'success'
        current_user.update_attribute(:actioned, true)
        if !current_room.users.where(actioned: false).exists?
          post_data({class: 'notification', message: 'everyone_succeed'})
        end
      end
    end
  end
  def post_data(data) # サーバーからデータを全員に通知したい場合に呼び出す
    RoomChannel.broadcast_to(current_user.room_id, body: data, from: current_user.name)
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