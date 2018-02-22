class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for cuser
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
