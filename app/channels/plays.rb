module Plays
  def route
    case @params['class']
      when 'start'  # 開始ボタンを押す
        if @current_room.playing? == true then return end
        @current_room.skip_search_validation = true
        @current_room.update_attributes(allow_enter: false, playing: true)

        # 全変数の初期化
        @current_room.update_attribute(:play_data, {system: {}, play: {}})
        @current_room.users.each do |user|
          user.update_attribute(:play_data, {
              system: {
                  active: true,
                  prg_pointer: [
                      {phase: 'title', phs_pointer: 0}
                  ],
                  view_objects: {}
              },
              play: {}
          })
        end

        # プレイ開始したので、全員play画面に移行する
        RoomChannel.broadcast_to(@current_room, {code: "setTimeout(function(){location.href = '/';}, #{@current_user.member_id * 200});"})

      when 'end' # 終了ボタンを押す
        # プレイ終了
        if @current_room.playing? == false then return end
        # playingをfalseにする
        @current_room.skip_search_validation = true
        @current_room.update_attributes(allow_enter: true, playing: false)

        # 全変数の削除
        @current_room.update_attribute(:play_data, nil)
        @current_room.users.each do |user|
          user.update_attribute(:play_data, nil)
        end

        # プレイ終了したので、全員room画面に移行する
        RoomChannel.broadcast_to(@current_room, {code: "setTimeout(function(){location.href = '/';}, #{@current_user.member_id * 200});"})

      when 'load' # ユーザーがページの更新したらここへ
        do_phase(@current_user.id)
      when 'action' # ユーザーがデータをActionCable経由で与えてきたらここへ
        action(@params['data'])
    end
  end

  def do_phase(user_id)
    user = User.find_by(id: user_id)

    case [user.play_data[:system][:prg_pointer][-1][:phase], user.play_data[:system][:prg_pointer][-1][:phs_pointer]] # 現在のフェイズと、フェイズ内での進行度によって振り分ける
      when ['title', 0] # タイトルフェイズ 進行度0の場合、アニメーションを表示する
        code = ""
        # ビューオブジェクトの追加
        user.play_data[:system][:view_objects][:title] = ViewObject.new('title',:HeadText,
                                                                       {
                                                                           text: '汝は人狼なりや?',
                                                                           left: 50,
                                                                           size: 6,
                                                                           home: :center
                                                                       })
        code += user.play_data[:system][:view_objects][:title].to_js

        # アニメーションの設定
        animations = Animations.new
        animations.append({timing: 0, id: :title, start: {opacity: 0, top: 50}, end: {opacity: 1, top: 30}, time: 1})

        user.play_data[:system][:view_objects] = animations.update_view_objects(user.play_data[:system][:view_objects])
        code += animations.to_js

        # 進行度+1
        user.play_data[:system][:prg_pointer][-1][:phs_pointer] += 1

        puts user.play_data[:system][:view_objects]

        # プレイデータの更新とフロントでのコードの実行
        user.update_attribute(:play_data, user.play_data)
        UserChannel.broadcast_to(user, {code: code})
      when ['title', 1] # アニメーションを表示中の場合
        code = ""
        user.play_data[:system][:view_objects].each_key do |key|
          puts key
          code += user.play_data[:system][:view_objects][key].to_js
        end
        UserChannel.broadcast_to(user, {code: code})
    end
  end
  def action(data)
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

  def all_actioned?
    phase = @current_user.play_data[:system][:prg_pointer][-1][:phase]
    sp = @current_user.play_data[:system][:prg_pointer].length - 1
    @current_room.users.each do |user|
      if user.play_data[:system][:prg_pointer][sp] && user.play_data[:system][:prg_pointer][sp][:phase] == phase && !user.play_data[:system][:prg_pointer][sp][:actioned]
        return false
      end
    end
    return true
  end

  def goto(phase)
    sp = @current_user.play_data[:system][:prg_pointer].length - 1
    @current_room.users.each do |user|
      user.play_data[:system][:prg_pointer] = (sp > 0 ? user.play_data[:system][:prg_pointer][0..(sp - 1)] : [])
      user.play_data[:system][:prg_pointer].append({phase: phase, phs_pointer: 0})
      user.update_attribute(:play_data, user.play_data)
    end
    @current_room.users.each do |user|
      do_phase(user)
    end
  end
end