module Plays
  require 'json'
  def debug
    p("USER PLAY_DATA:#{@current_user}")
    p("ROOM PLAY_DATA:#{@current_room}")
    p("DATA #{@params}")
  end
  def input
    case @params['class']
      when 'start'  # 開始ボタンを押す
        if @current_room.playing? == true then return end
        @current_room.skip_search_validation = true
        @current_room.update_attributes(allow_enter: false, playing: true)

        # 全変数の初期化
        @current_room.update_attribute(:play_data, {system: {}, play: {}})
        @current_room.users.each do |user|
          user.update_attribute(:play_data, {system: {prg_pointer: [{phase: 'title', actioned: false}]}, play: {}})
        end

        # プレイ開始したので、全員play画面に移行する
        RoomChannel.broadcast_to(croom, {code: "setTimeout(function(){location.href = '/';}, #{@current_user.member_id * 200});"})

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
        RoomChannel.broadcast_to(croom, {code: "setTimeout(function(){location.href = '/';}, #{@current_user.member_id * 200});"})

      when 'load' #
        code = ""
        code += text_object(text: 'Wake Me Up')
        puts code
        UserChannel.broadcast_to(cuser, {code: code})
    end
  end

  def text_object(params)
    params[:tag] = 'span' if !params[:tag]
    option = {}
    option[:text] = params[:text] if params[:text]
    return "$(\"#play-screen\").append($(\"<#{params[:tag]}></#{params[:tag]}>\", #{option.to_json}));"
  end
end