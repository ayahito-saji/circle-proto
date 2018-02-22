module Plays
  require 'json'
  def debug
    p("USER PLAY_DATA:#{@current_user}")
    p("ROOM PLAY_DATA:#{@current_room}")
    p("DATA #{@params}")
  end
  def route
    case @params['class']
      when 'start'  # 開始ボタンを押す
        if @current_room.playing? == true then return end
        @current_room.skip_search_validation = true
        @current_room.update_attributes(allow_enter: false, playing: true)

        # 全変数の初期化
        @current_room.update_attribute(:play_data, {system: {}, play: {}})
        @current_room.users.each do |user|
          user.update_attribute(:play_data, {system: {active: true, prg_pointer: [{phase: 'title', actioned: false}]}, play: {}})
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

      when 'load' # 全員これを処理する
        puts("!!!RELOAD!!!")
        draw(@current_user.id)
      when 'action' # 一人ずつ処理する
        if @current_user.play_data[:system][:prg_pointer][-1][:actioned] then return end
        case @current_user.play_data[:system][:prg_pointer][-1][:phase]
          when 'title'
            # 変数の書き換え
            @current_user.play_data[:system][:prg_pointer][-1][:actioned] = true
            @current_user.update_attribute(:play_data, @current_user.play_data)
            code = ""
            animation_data = [
                {timing: :after, id: 'start-btn', start: {opacity: 1}, end: {opacity: 0}, time: 1},
                {timing: :same, id: 'title', start: {opacity: 1}, end: {opacity: 0}, time: 1}
            ]
            code += object_animation(animation_data)
            UserChannel.broadcast_to(@current_user, {code: code})
            if all_actioned?
              goto 'job_set'
            end
        end
    end
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
      user.play_data[:system][:prg_pointer].append({phase: phase, actioned: false})
      user.update_attribute(:play_data, user.play_data)
    end
    @current_room.users.each do |user|
      do_phase(user)
    end
  end

  def do_phase(user)
    case user.play_data[:system][:prg_pointer][-1][:phase]
      when 'job_set'
        if user.member_id == 0
          job = ["werewolf"]
          (1...@current_room.users.count).each do
            job.append("civilian")
          end
          job.shuffle!
          @current_room.users.order(:member_id).each do |user|
            user.play_data[:play][:job] = job.shift
            user.update_attribute(:play_data, user.play_data)
          end
          @current_room.play_data[:play][:day] = 0
          @current_room.update_attribute(:play_data, @current_room.play_data)
        end
        draw(user.id)
    end
  end

  def draw(user_id)
    user = User.find_by(id: user_id)
    puts("☆★☆★ DRAW#{user.name}")
    puts("#{user.play_data}")
    case user.play_data[:system][:prg_pointer][-1][:phase]
      when 'title'
        code = ""
        code += text_object(id: 'title', text: '汝は人狼なりや.', home: 'center', top: 40, left: 50, size: 5, opacity: 1)
        if !user.play_data[:system][:prg_pointer][-1][:actioned]
          code += text_object(tag: 'a', id: 'start-btn', text: 'GameStart', home: 'center', top: 70, left: 50, size: 3, opacity: 1)
        end
        code += "$('#start-btn').on('click', function(){App.room.write({'class': 'action'})});"
        animation_data = [
            {timing: 0, id: 'title', start: {opacity: 0, top: 50}, end: {opacity: 1, top: 30}, time: 1},
            {timing: :after, id: 'start-btn', start: {opacity: 0}, end: {opacity: 1}, time: 1}
        ]
        code += object_animation(animation_data)
        UserChannel.broadcast_to(user, {code: code})
      when 'job_set'
        code = ""
        code += text_object(id: 'job_set', text: "あなたは#{user.play_data[:play][:job]}です", home: 'center', top: 30, left: 50, size: 3, opacity: 1)
        animation_data = [
            {timing: 0, id: 'job_set', start: {opacity: 0, top: 50}, end: {opacity: 1, top: 30}, time: 1}
        ]
        code += object_animation(animation_data)
        UserChannel.broadcast_to(user, {code: code})
    end
  end
end