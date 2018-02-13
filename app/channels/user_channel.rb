class UserChannel < ApplicationCable::Channel
  include PlaysHelper
  include EntrancesHelper
  include RoomsHelper
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # クライアントから読み込んだデータ(params)
  def read(data)
    get_data(data)
  end
end
