module PlaysHelper
  def play_start
    # プレイ開始
    if current_room.playing? == true
      return
    end
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: false, playing: true)

    # 全変数の初期化
    current_room.update_attribute(:play_data, {})
    p current_room.play_data
    current_room.users.each do |user|
      var = {
          system: {
              prg_pointer: [{phase: 'title', actioned: false}]
          },
          play: {}
      }
      user.update_attribute(:play_data, var)
      #puts("#{user.name}: #{user.play_data}")
    end
    # プレイ開始したので、全員play画面に移行する
    RoomChannel.broadcast_to(current_room,
                             {
                                 code: "setTimeout(function(){location.href = '/';}, #{current_user.member_id * 200});"
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

    # 全変数の削除
    current_room.update_attribute(:play_data, nil)
    current_room.users.each do |user|
      user.update_attribute(:play_data, nil)
    end

    # プレイ終了したので、全員room画面に移行する
    RoomChannel.broadcast_to(current_room,
                             {
                                 code: "setTimeout(function(){location.href = '/';},100);"
                             })
  end
  def do_phase(phase)
    case phase
      when 'job_set'
        current_room.users.order(:member_id).each do |user|
          if user.member_id == 0
            job = ["werewolf"]
            (1...current_room.users.count).each do
              job.append("civilian")
            end
            job.shuffle!
            current_room.users.order(:member_id).each do |user|
              user.play_data[:play][:job] = job.shift
              user.update_attribute(:play_data, user.play_data)
            end
          end
        end
        current_room.users.order(:member_id).each do |user|
          code = "$('#play-screen').empty();"
          code += play_view_code(user)
          UserChannel.broadcast_to(user, {code: code})
        end
    end
  end
  def play_view_code(user)
    play_data = user_play_data(user)
    code = ""
    case play_data[:system][:prg_pointer][-1][:phase]
      when 'title'
        # タイトルオブジェクトの設定
        code += "var obj_0 = document.createElement(\"span\");"
        code += "obj_0.setAttribute('id', 'obj_0');"
        code += "obj_0.style.position = \"absolute\";"
        code += "obj_0.style.top = \"40%\";"
        code += "obj_0.style.left = \"50%\";"
        code += "obj_0.style.webkitTransform = \"translate(-50%,-50%)\";"
        code += "obj_0.style.transform = \"translate(-50%,-50%)\";"
        code += "obj_0.style.color = \"#ffffff\";"
        code += "obj_0.style.fontSize = \"5vw\";"
        code += "obj_0.appendChild(document.createTextNode('汝は人狼なりや。'));"
        code += "$('#play-screen').append(obj_0);"
        if play_data[:system][:prg_pointer][-1][:actioned] == false
          # ボタンオブジェクト
          code += "var obj_1 = document.createElement('a');"
          code += "obj_1.setAttribute('id', 'obj_1');"
          code += "obj_1.setAttribute('href', 'javascript:void(0);');"
          code += "obj_1.style.position = 'absolute';"
          code += "obj_1.style.top = '80%';"
          code += "obj_1.style.left = '50%';"
          code += "obj_1.style.webkitTransform = 'translate(-50%,-50%)';"
          code += "obj_1.style.transform = 'translate(-50%,-50%)';"
          code += "obj_1.style.color = '#ffffff';"
          code += "obj_1.style.fontSize = '3vw';"
          code += "obj_1.appendChild(document.createTextNode('GameStart'));"
          code += "$('#play-screen').append(obj_1);"
          code += "$('#obj_1').on('click', function(){App.room.write({'class': 'input'})});"
        end
      when 'job_set'
        code += "var obj_0 = document.createElement(\"span\");"
        code += "obj_0.setAttribute('id', 'obj_0');"
        code += "obj_0.style.position = \"absolute\";"
        code += "obj_0.style.top = \"10%\";"
        code += "obj_0.style.left = \"50%\";"
        code += "obj_0.style.webkitTransform = \"translate(-50%,-50%)\";"
        code += "obj_0.style.transform = \"translate(-50%,-50%)\";"
        code += "obj_0.style.color = \"#ffffff\";"
        code += "obj_0.style.fontSize = \"4vw\";"
        code += "obj_0.appendChild(document.createTextNode('あなたは#{play_data[:play][:job]}です'));"
        code += "$('#play-screen').append(obj_0);"

        code += "var obj_1 = document.createElement(\"div\");"
        code += "obj_1.setAttribute('id', 'obj_1');"
        code += "obj_1.style.position = \"absolute\";"
        code += "obj_1.style.top = \"30%\";"
        code += "obj_1.style.left = \"10%\";"
        code += "obj_1.style.width = \"80%\";"
        code += "obj_1.style.height = \"60%\";"
        code += "obj_1.style.color = \"#ffffff\";"
        code += "obj_1.style.fontSize = \"2vw\";"
        code += "obj_1.appendChild(document.createTextNode('～役職の説明～'));"
        code += "obj_1.appendChild(document.createElement(\"br\"));"
        code += "$('#play-screen').append(obj_1);"

        if play_data[:system][:prg_pointer][-1][:actioned] == false
          # ボタンオブジェクト
          code += "var obj_2 = document.createElement('a');"
          code += "obj_2.setAttribute('id', 'obj_2');"
          code += "obj_2.setAttribute('href', 'javascript:void(0);');"
          code += "obj_2.style.position = 'absolute';"
          code += "obj_2.style.top = '80%';"
          code += "obj_2.style.left = '50%';"
          code += "obj_2.style.webkitTransform = 'translate(-50%,-50%)';"
          code += "obj_2.style.transform = 'translate(-50%,-50%)';"
          code += "obj_2.style.color = '#ffffff';"
          code += "obj_2.style.fontSize = '3vw';"
          code += "obj_2.appendChild(document.createTextNode('では、惨劇の幕開けだ'));"
          code += "$('#play-screen').append(obj_2);"
          code += "$('#obj_2').on('click', function(){App.room.write({'class': 'input'})});"
        end
    end
    return code.html_safe;
  end
  def get_data(data)
    puts("DATA:#{data} FROM:#{current_user.name}")
    play_data = user_play_data(current_user)
    case data['class']
      when 'start'
        play_start
      when 'end'
        play_end
      when 'input'
        case play_data[:system][:prg_pointer][-1][:phase]
          when 'title'
            # 変数の書き換え
            current_user.play_data[:system][:prg_pointer][-1][:actioned] = true
            current_user.update_attribute(:play_data, current_user.play_data)

            # 自分だけが実行するコード
            code = ""
            code += "$(\"#obj_1\").hide();"
            UserChannel.broadcast_to(current_user, {code: code})

            if all_actioned?(play_data[:system][:prg_pointer].length - 1)
              phase_change('job_set')
            end
          when 'job_set'
            # 変数の書き換え
            current_user.play_data[:system][:prg_pointer][-1][:actioned] = true
            current_user.update_attribute(:play_data, current_user.play_data)

            # 自分だけが実行するコード
            code = ""
            code += "$(\"#obj_2\").hide();"
            UserChannel.broadcast_to(current_user, {code: code})

            if all_actioned?(play_data[:system][:prg_pointer].length - 1)
              phase_change('day')
            end
        end
    end
  end
  # 同じフェイズ、同じ関数内で全員アクション済みならtrue、そうでなければfalseを返す
  def all_actioned?(cpp)
    current_room.users.each do |user|
      play_data = user_play_data(user)
      if play_data[:system][:prg_pointer][cpp] && play_data[:system][:prg_pointer][cpp][:actioned] == false
        return false
      end
    end
    return true
  end
  # (全員の)フェイズを変更して、処理を行う
  def phase_change(phase)
    current_room.users.each do |user|
      play_data = user_play_data(user)
      play_data[:system][:prg_pointer] = [{phase: phase, actioned: false}]
      user.update_attribute(:play_data, play_data)
    end
    do_phase(phase)
  end

  def user_play_data(user)
    User.select(:id, :play_data).find_by(id:user.id).play_data
  end
  def room_play_data(room)
    Room.select(:id, :play_data).find_by(id: room.id).play_data
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