module PlaysHelper
  def do_phase(phase, current_user_id, currnt_room_id) # この関数は、フェイズ実行時に一度しか実行されない
    # 表示する前のフェイズで実行するコード
    current_room.users.order(:member_id).each do |user| # 全員分のフェイズを実行する
      case phase
        when 'job_set'
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
            current_room.play_data[:play][:day] = 0
            current_room.update_attribute(:play_data, current_room.play_data)
          end
        when 'day'
          current_room.play_data[:play][:day] += 1
          current_room.update_attribute(:play_data, current_room.play_data)

      end
    end
    # 画面表示のためのコード
    current_room.users.order(:member_id).each do |user|
      case phase
        when 'job_set'
          code = "$('#play-screen').empty();"
          code += play_view_code(user)
          UserChannel.broadcast_to(user, {code: code})
        when 'day'
          code = "$('#play-screen').empty();"
          code += play_view_code(user)
          UserChannel.broadcast_to(user, {code: code})
      end
    end
  end
  def play_view_code(user)
    puts(user.play_data)
    code = ""
    case user.play_data[:system][:prg_pointer][-1][:phase]
      when 'title'
        # タイトルオブジェクトの設定
        code += text_object(0, "汝は人狼なりや?", 5, 40, 50, {home: 'center'})
        if user.play_data[:system][:prg_pointer][-1][:actioned] == false
          # ボタンオブジェクト
          code += text_object(1, "ゲームスタート", 3, 80, 50, {home: 'center', tag: 'a'})
          code += "$('#obj_1').on('click', function(){App.room.write({'class': 'input'})});"
        end
      when 'job_set'
        # 役職の発表
        code += text_object(0, "あなたは#{user.play_data[:play][:job]}です", 4, 10, 50, {home: 'center'})
        code += "$('#play-screen').append(obj_0);"
        # 役職の説明ボックス
        code += text_object(1, "～役職の説明～", 2, 30, 10, {home: 'center'})

        if user.play_data[:system][:prg_pointer][-1][:actioned] == false
          # ボタンオブジェクト
          code += text_object(2, "夜があけた", 3, 80, 50, {home: 'center', tag: 'a'})
          code += "$('#obj_2').on('click', function(){App.room.write({'class': 'input'})});"
        end
      when 'day'
        code += text_object(0, "#{current_room.play_data[:play][:day]}日目", 4, 10, 10, {})
        code += "$('#play-screen').append(obj_0);"
    end
    return code.html_safe;
  end
  def get_data(data, current_user, current_room)
    puts("DATA:#{data} FROM:#{current_user.name}")
    case data['class']
      when 'start'
        play_start(current_user, current_room)
      when 'end'
        play_end(current_user, current_room)
      when 'input'
        puts(current_user.play_data)
        case current_user.play_data[:system][:prg_pointer][-1][:phase]
          when 'title'
            # 変数の書き換え
            current_user.play_data[:system][:prg_pointer][-1][:actioned] = true
            current_user.update_attribute(:play_data, current_user.play_data)

            # 自分だけが実行するコード
            code = ""
            code += "$(\"#obj_1\").hide();"
            UserChannel.broadcast_to(current_user, {code: code})
            if all_actioned?(current_user.play_data[:system][:prg_pointer].length - 1)
              phase_change('job_set')
            end
          when 'job_set'
            puts('職業設定でokを押した')
            # 変数の書き換え
            current_user.play_data[:system][:prg_pointer][-1][:actioned] = true
            current_user.update_attribute(:play_data, current_user.play_data)

            # 自分だけが実行するコード
            code = "alert('職業決定でok押したよ');"
            code += "$(\"#obj_2\").hide();"
            UserChannel.broadcast_to(current_user, {code: code})

            if all_actioned?(current_user.play_data[:system][:prg_pointer].length - 1)
              puts('日中になるはずです')
              phase_change('day')
            end
          when 'day'
            # 変数の書き換え
            current_user.play_data[:system][:prg_pointer][-1][:actioned] = true
            current_user.update_attribute(:play_data, current_user.play_data)
            phase_change('twilight')
        end
    end
  end
  # 同じフェイズ、同じ関数内で全員アクション済みならtrue、そうでなければfalseを返す
  def all_actioned?(cpp)
    current_room.users.each do |user|
      if user.play_data[:system][:prg_pointer][cpp] && user.play_data[:system][:prg_pointer][cpp][:actioned] == false
        return false
      end
    end
    return true
  end
  # (全員の)フェイズを変更して、処理を行う
  def phase_change(phase)
    current_room.users.each do |user|
      buf = user
      buf.play_data[:system][:prg_pointer] = [{phase: phase, actioned: false}]
      buf.update_attribute(:play_data, buf.play_data)
    end
    do_phase(phase)
  end

  # テキストオブジェクト
  def text_object(id, text, font_size, top, left, option)
    if option[:tag]
      code = "var obj_#{id} = document.createElement(\"#{option[:tag]}\");"
      if option[:tag] == 'a'
        code += "obj_#{id}.setAttribute('href', 'javascript:void(0);');"
      end
    else
      code = "var obj_#{id} = document.createElement(\"span\");"
    end
    code += "obj_#{id}.setAttribute('id', 'obj_#{id}');"
    code += "obj_#{id}.style.position = \"absolute\";"
    code += "obj_#{id}.style.top = \"#{top}%\";"
    code += "obj_#{id}.style.left = \"#{left}%\";"
    if option[:home] == 'center'
      code += "obj_#{id}.style.webkitTransform = \"translate(-50%,-50%)\";"
      code += "obj_#{id}.style.transform = \"translate(-50%,-50%)\";"
    end
    code += "obj_#{id}.style.color = \"#ffffff\";"
    code += "obj_#{id}.style.fontSize = \"#{font_size}vw\";"
    code += "obj_#{id}.appendChild(document.createTextNode('#{text}'));"
    code += "$('#play-screen').append(obj_#{id});"
    return code
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

  def play_start(current_user, current_room)
    # プレイ開始
    if current_room.playing? == true then return end
    # playingをtrueにする
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: false, playing: true)

    # 全変数の初期化
    current_room.update_attribute(:play_data, {system: {}, play: {}})
    current_room.users.each do |user|
      user.update_attribute(:play_data, {system: {prg_pointer: [{phase: 'title', actioned: false}]}, play: {}})
    end
    # プレイ開始したので、全員play画面に移行する
    RoomChannel.broadcast_to(current_room, {code: "setTimeout(function(){location.href = '/';}, #{current_user.member_id * 200});"})
  end
  def play_end(current_user, current_room)
    # プレイ終了
    if current_room.playing? == false then return end
    # playingをfalseにする
    current_room.skip_search_validation = true
    current_room.update_attributes(allow_enter: true, playing: false)

    # 全変数の削除
    current_room.update_attribute(:play_data, nil)
    current_room.users.each do |user|
      user.update_attribute(:play_data, nil)
    end

    # プレイ終了したので、全員room画面に移行する
    RoomChannel.broadcast_to(current_room, {code: "setTimeout(function(){location.href = '/';},100);"})
  end
end