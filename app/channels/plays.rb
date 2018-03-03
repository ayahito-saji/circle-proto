module Plays
  def route(params)
    case params['class']
      when 'start'  # 開始ボタンを押す
        room = Room.find_by(id: @room_id)
        if room.playing? == true then return end
        room.skip_search_validation = true
        room.update_attributes(allow_enter: false, playing: true)

        # 全変数の初期化
        room.update_attribute(:play_data, {system: {}, play: {}})
        room.users.each do |user|
          user.update_attribute(:play_data, {
              system: {
                  active: true,
                  prg_pointer: [
                      {phase: 'title', phs_pointer: -1}
                  ],
                  view_objects: {}
              },
              play: {}
          })
        end

        # プレイ開始したので、全員play画面に移行する
        RoomChannel.broadcast_to(room, {code: "location.href = '/';", class: "push"})

      when 'end' # 終了ボタンを押す
        # プレイ終了
        room = Room.find_by(id: @room_id)
        if room.playing? == false then return end
        # playingをfalseにする
        room.skip_search_validation = true
        room.update_attributes(allow_enter: true, playing: false)

        # 全変数の削除
        room.update_attribute(:play_data, nil)
        room.users.each do |user|
          user.update_attribute(:play_data, nil)
        end

        # プレイ終了したので、全員room画面に移行する
        RoomChannel.broadcast_to(room, {code: "location.href = '/';", class: "push"})

      when 'load' # ユーザーがページの更新したらここへ
        do_phase(:get, @user_id, nil, nil)
      when 'action' # ユーザーがデータをActionCable経由で与えてきたらここへ
        do_phase(:post, @user_id, params['data'], nil)
    end
  end

  def do_phase(method, user_id, data, user)
    user = User.find_by(id: user_id) if user.nil?


    case [user.play_data[:system][:prg_pointer][-1][:phase], user.play_data[:system][:prg_pointer][-1][:phs_pointer]] # 現在のフェイズと、フェイズ内での進行度によって振り分ける
      when ['title', -1] # system的な初期化
        user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 0
        user.update_attribute(:play_data, user.play_data)
        do_phase(:nil, user_id, nil, user)

      when ['title', 0] # animation
        if method == :nil # アニメーション開始
          code = ""

          user.play_data[:system][:view_objects][:title] = ViewObject.new('title',:HeadText, {text: '汝は人狼なりや?', left: 50, size: 6, home: :center})
          code += user.play_data[:system][:view_objects][:title].to_js
          user.play_data[:system][:view_objects][:start_button] = ViewObject.new('start_button', :AquaButton, {text: 'ゲーム開始', left: 50, size: 4, width: 20, height: 15, home: :center, on:{click: "App.room.write({'class': 'action'});"}})
          code += user.play_data[:system][:view_objects][:start_button].to_js

          animations = Animations.new
          animations.append({timing: 0, id: :title, start: {opacity: 0, top: 50}, end: {opacity: 1, top: 30}, time: 1})
          animations.append({timing: :after, id: :start_button, start: {opacity: 0, top: 80}, end: {opacity: 1, top: 70}, time: 0.5})
          user.play_data[:system][:view_objects] = animations.update_view_objects(user.play_data[:system][:view_objects])
          code += animations.to_js("App.room.write({'class': 'action'});")

          user.update_attribute(:play_data, user.play_data)
          UserChannel.broadcast_to(user, {code: code, class: "push"})
        elsif method == :get # アニメーション中に読み込み
          code = ""
          user.play_data[:system][:view_objects].each_key do |key|
            code += user.play_data[:system][:view_objects][key].to_js
          end
          UserChannel.broadcast_to(user, {code: code, class: "load"})
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 1
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)

        elsif method == :post # アニメーション終了時
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 1
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)
        end

      when ['title', 1] # input
        if method == :nil # input待機開始時
        elsif method == :get # input待機中に読み込み
          code = ""
          user.play_data[:system][:view_objects].each_key do |key|
            code += user.play_data[:system][:view_objects][key].to_js
          end
          UserChannel.broadcast_to(user, {code: code, class: "load"})
        elsif method == :post # input待機中に入力あり
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 2
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)
        end

      when ['title', 2] # animation
        if method == :nil # アニメーション開始
          code = ""

          animations = Animations.new
          animations.append({timing: 0, id: :start_button, start: {opacity: 1}, end: {opacity: 0}, time: 0.5})
          user.play_data[:system][:view_objects] = animations.update_view_objects(user.play_data[:system][:view_objects])
          code += animations.to_js("$(\"#_start_button\").remove();App.room.write({'class': 'action'});")

          user.play_data[:system][:view_objects].delete(:start_button)

          user.update_attribute(:play_data, user.play_data)
          UserChannel.broadcast_to(user, {code: code, class: "push"})

        elsif method == :get # アニメーション中に読み込み
          code = ""
          user.play_data[:system][:view_objects].each_key do |key|
            code += user.play_data[:system][:view_objects][key].to_js
          end
          UserChannel.broadcast_to(user, {code: code, class: "load"})
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 3
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)

        elsif method == :post # アニメーション終了時
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 3
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)
        end
      when ['title', 3] # all_actioned?
        room = Room.find_by(id: user.room_id)
        if all_actioned?(user, room)
          room.users.each do |u|
            u.play_data[:system][:prg_pointer][-1][:phs_pointer] = 4
            u.update_attribute(:play_data, u.play_data)
            do_phase(:nil, u.id, nil, u)
          end
        end
      when ['title', 4] # animation
        if method == :nil # アニメーション開始
          code = ""

          animations = Animations.new
          animations.append({timing: 0, id: :title, start: {opacity: 1}, end: {opacity: 0}, time: 0.5})
          user.play_data[:system][:view_objects] = animations.update_view_objects(user.play_data[:system][:view_objects])
          code += animations.to_js("$(\"#_title\").remove();App.room.write({'class': 'action'});")

          user.play_data[:system][:view_objects].delete(:title)

          user.update_attribute(:play_data, user.play_data)
          UserChannel.broadcast_to(user, {code: code, class: "push"})

        elsif method == :get # アニメーション中に読み込み
          code = ""
          user.play_data[:system][:view_objects].each_key do |key|
            code += user.play_data[:system][:view_objects][key].to_js
          end
          UserChannel.broadcast_to(user, {code: code, class: "load"})
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 5
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)

        elsif method == :post # アニメーション終了時
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 5
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)
        end
      when ['title', 5] # goto
        user.play_data[:system][:prg_pointer].delete_at(-1)
        user.play_data[:system][:prg_pointer].append({phase: "job_set", phs_pointer: 0})
        user.update_attribute(:play_data, user.play_data)
        do_phase(:nil, user_id, nil, user)
      when ['job_set', 0]
        if method == :nil # アニメーション開始
          code = ""

          user.play_data[:system][:view_objects][:job] = ViewObject.new('job',:HeadText, {text: 'あなたは人狼です', top: 20, left: 30, size: 4, home: :center})
          code += user.play_data[:system][:view_objects][:job].to_js
          user.play_data[:system][:view_objects][:next_button] = ViewObject.new('next_button', :AquaButton, {text: '次へ進む', left: 80, size: 4, width: 20, height: 15, home: :center, on:{click: "App.room.write({'class': 'action'});"}})
          code += user.play_data[:system][:view_objects][:next_button].to_js

          animations = Animations.new
          animations.append({timing: 0, id: :job, start: {opacity: 0}, end: {opacity: 1}, time: 0.5})
          animations.append({timing: :after, id: :next_button, start: {opacity: 0, top: 90}, end: {opacity: 1, top: 80}, time: 0.5})
          user.play_data[:system][:view_objects] = animations.update_view_objects(user.play_data[:system][:view_objects])
          code += animations.to_js("App.room.write({'class': 'action'});")

          user.update_attribute(:play_data, user.play_data)
          UserChannel.broadcast_to(user, {code: code, class: "push"})
        elsif method == :get # アニメーション中に読み込み
          code = ""
          user.play_data[:system][:view_objects].each_key do |key|
            code += user.play_data[:system][:view_objects][key].to_js
          end
          UserChannel.broadcast_to(user, {code: code, class: "load"})
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 1
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)

        elsif method == :post # アニメーション終了時
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 1
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)
        end
      when ['job_set', 1] # input
        if method == :nil # input待機開始時
        elsif method == :get # input待機中に読み込み
          code = ""
          user.play_data[:system][:view_objects].each_key do |key|
            code += user.play_data[:system][:view_objects][key].to_js
          end
          UserChannel.broadcast_to(user, {code: code, class: "load"})
        elsif method == :post # input待機中に入力あり
          user.play_data[:system][:prg_pointer][-1][:phs_pointer] = 2
          user.update_attribute(:play_data, user.play_data)
          do_phase(:nil, user_id, nil, user)
        end
    end
  end

  def set_timer(hour, min, sec)
    time = Time.now
    time += hour * 3600 + min * 60 + sec
    return time.to_s
  end
  def timer_view(time_str)
    time_str.gsub!(/-/, '/')
    return "var time_limit = Date.parse(\"#{time_str}\");var timer = setInterval(function(){var time_now = new Date();var time_left = Math.floor((time_limit - time_now) / 1000);$(\"#timer\").text((\"0\"+Math.floor(time_left/3600)).slice(-2)+\":\"+(\"0\"+Math.floor((time_left%3600)/60)).slice(-2)+\":\"+(\"0\"+time_left%60).slice(-2));}, 100);"
  end

  def all_actioned?(user, room)
    sp = user.play_data[:system][:prg_pointer].length - 1
    room.users.each do |u|
      if  u.play_data[:system][:prg_pointer][sp] &&
          u.play_data[:system][:prg_pointer][sp][:phase] == user.play_data[:system][:prg_pointer][sp][:phase] &&
          u.play_data[:system][:prg_pointer][sp][:phs_pointer] < user.play_data[:system][:prg_pointer][sp][:phs_pointer]
        return false
      end
    end
    return true
  end
end