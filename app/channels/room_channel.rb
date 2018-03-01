class RoomChannel < ApplicationCable::Channel
  include Plays
  include PlayObjects
  def subscribed
    # stream_from "some_channel"
    stream_for croom
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def read(data)
    @current_user = User.find_by(id: cuser)
    @current_room = Room.find_by(id: croom)
    @params = data['params']
    route
  end
end