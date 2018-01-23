class RoomsController < ApplicationController
  before_action :require_login
  def create
    @room = Room.new
    @room.maximum = -1 if current_user.premium?
    if @room.save
      enter @room
      redirect_to root_path
    else
      flash.now[:danger] = "Create room error."
      redirect_to root_path
    end
  end
end
