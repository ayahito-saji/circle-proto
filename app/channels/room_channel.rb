class RoomChannel < ApplicationCable::Channel
  include PlaysHelper
  def subscribed
    stream_from "room_channel"
    stream_for current_user.room_id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def server_get(arg)
    get_data(arg['body'], false)
  end
  #def server_post(data)
    # 部屋に入っている人全員につながる
    # ActionCable.server.broadcast 'room_channel', data: "BroadCast!"
    # (current_user.room_id)に接続している人につながる
    # RoomChannel.broadcast_to(current_user.room_id, body: data, from: current_user.name)
  #end
end
