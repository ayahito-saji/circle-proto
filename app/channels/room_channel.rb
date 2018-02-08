class RoomChannel < ApplicationCable::Channel
  include PlaysHelper
  def subscribed
    stream_from "room_channel"
    stream_for current_user.room_id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  # データをクライアントサイドから受け取って、PlaysHelper内のget_dataへ渡す
  def server_get(arg)
    get_data(arg['body'], true)
  end
end
