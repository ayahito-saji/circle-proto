class RoomsController < ApplicationController
  before_action :require_login
  before_action :require_enter, only: [:edit, :update]
  def create
    @room = Room.new
    @room.maximum = -1 if current_user.premium?
    @room.name = "dummy_room_name"
    @room.password = "dummy_room_password"
    @room.skip_name_uniqueness = true
    if @room.save
      enter @room
      redirect_to root_path
    else
      flash.now[:danger] = "Create room error."
      redirect_to root_path
    end
  end
  def edit
  end
  def update
  end
end
