class RoomChannel < ApplicationCable::Channel
  include PlaysHelper
  include EntrancesHelper
  include RoomsHelper
  def subscribed
    # stream_from "some_channel"
    stream_for current_room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def read(data)
    get_data(data)
  end
end
