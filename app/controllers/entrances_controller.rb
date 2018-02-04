class EntrancesController < ApplicationController
  before_action :require_login, only: [:show, :create]
  before_action :require_enter, only: [:show, :destroy]
  def new
    if !params[:p].nil?
      remember_room_token params[:p]
    end
    if login?
      if remember_room_token?
        room = Room.find_by(token: current_room_token)
        forget_room_token
        if !room.nil?
          if current_room.id == room.id # 現在のルームと同じ部屋に入ろうとしていたらrootパスへと移動する
            redirect_to root_path
            return
          end
          if enter room
            RoomChannel.broadcast_to(current_user.room_id, body: "Entered", from: current_user.name)
            redirect_to root_path
            return
          else
            flash.now[:danger] = "The room is already full of members.(7/7)"
          end
        else
          flash.now[:danger] = "The room URL doesn't exist"
        end
      end
    else
      redirect_to root_path
      return
    end

  end

  def create
  end

  def show
  end

  def destroy
    RoomChannel.broadcast_to(current_user.room_id, body: "Exited", from: current_user.name)
    exit
    redirect_to root_path
  end
end
