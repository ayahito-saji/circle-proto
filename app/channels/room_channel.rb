class RoomChannel < ApplicationCable::Channel
  include Plays
  include PlayObjects
  def subscribed
    # stream_from "some_channel"
    stream_for croom
    @user_id = cuser.id
    @room_id = croom.id
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def read(data)
    route data['params']
  end
end