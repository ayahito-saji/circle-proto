class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # クライアントから読み込んだデータ(params)
  def read(params)
    UserChannel.broadcast_to(current_user, params['data'])
  end

  # ルーム全員にブロードキャストする(except: []で例外を指定できる)
  def broadcast_to_room(room, data, **option)
    room.users.each do |user|
      if !option[:except] || !option[:except].include?(user)
        puts(user)
        UserChannel.broadcast_to(user, data)
      end
    end
  end
end
