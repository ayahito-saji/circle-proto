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
    broadcast_to_room(current_room, {class: 'redirect', to: root_path}, except: [current_user])
  end
  # プレイ強制終了する時に呼び出される
  def play_end
    # プレイ終了
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: true, playing: false)

    # プレイ終了したので、全員room画面に移行する
    broadcast_to_room(current_room, {class: 'redirect', to: room_path}, except: [current_user])
  end

  def play_view # プレイ開始時または再読み込み、再アクセスした際に呼び出される
    html_code = ""
    cmn_var = current_room.var

    if cmn_var[:system][:status] == 'title'
      html_code = "<h1>人狼ゲームはっじまるよー</h1>"
      if !current_user.actioned?
        html_code += "<p><a href='javascript:void(0)' onclick=\"done(),$('#link').hide()\" id='link'>Start</a></p>"
      end
    end

    #表示するHTMLコードを返す
    html_code.html_safe
  end
  def get_data(data)
    puts("DATA:#{data} FROM:#{current_user.name}")
    if data['class'] == 'input'
      puts(current_user)
      puts("BEFORE ATTRIBUTE#{current_user.actioned?}")
      puts(current_user.update_attribute(:actioned, true))
      puts("AFTER ATTRIBUTE#{current_user.actioned?}")

      #if !current_room.users.where(actioned: false).exists?
        #broadcast_to_room(current_room,{'class': 'notification', 'code': 'all_submitted', member_id: current_user.member_id})
      #else
        #broadcast_to_room(current_room,{'class': 'notification', 'code': 'any_submitted', 'member_id': current_user.member_id})
      #end
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