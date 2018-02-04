class RoomsController < ApplicationController
  before_action :require_login
  before_action :reject_enter, only: [:create]
  before_action :require_enter, only: [:show, :edit, :update]
  def create
    @room = Room.new
    @room.maximum = -1 if current_user.premium?
    @room.skip_search_validation = true
    if @room.save
      enter @room
      redirect_to root_path
    else
      flash[:danger] = "Create room error."
      redirect_to root_path
    end
  end
  def show
  end
  def edit
    @room = current_room
  end
  def update
    current_room.skip_search_validation = room_params[:allow_search].to_i.zero?
    if current_room.update_attributes(room_params)
      flash[:success] = "Success update room setting"
      redirect_to root_path
    else
      flash[:danger] = "Some Error occured"
      redirect_to room_setting_path
    end
  end

  private
  def room_params
    params.require(:room).permit(:name, :password, :allow_search)
  end
end
