class EntrancesController < ApplicationController

  def new
    if !params[:p].nil?
      room = Room.find_by(token: params[:p])
      if !room.nil?
        enter room
      else
        flash[:danger] = "invalid url"
      end
    end
    redirect_to root_path
  end

  def destroy
    exit
    redirect_to root_path
  end
end
