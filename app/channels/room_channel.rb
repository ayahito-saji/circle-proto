class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
    stream_for current_user.room_id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def server_get(arg)
    server_post(arg['body'])
  end
  def server_post(data)
    #部屋に入っている人全員につながる
    #ActionCable.server.broadcast 'room_channel', data: "BroadCast!"
    #(current_user.id)に接続している人につながる
    RoomChannel.broadcast_to(current_user.room_id, body: data, from: current_user.name)
  end
end
