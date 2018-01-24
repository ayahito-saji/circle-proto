class EntrancesController < ApplicationController

  def new
    if !params[:t].nil?
      room = Room.find_by(token: params[:t])
      if !room.nil?
        enter room
      else
        flash[:danger] = "invalid url"
      end
    end
    redirect_to root_path
  end

  def destroy
    exit_room = current_room
    exit
    if exit_room.users.count == 0
      exit_room.destroy
    end
    redirect_to root_path
  end
end
