class EntrancesController < ApplicationController
  before_action :require_login, only: [:new, :show]
  before_action :require_enter, only: [:show, :destroy]
  def new
    if !params[:p].nil?
      room = Room.find_by(token: params[:p])
      if !room.nil?
        if login?
          enter room
        else
          flash[:danger] = "login before entering room"
        end
      else
        flash[:danger] = "invalid url"
      end
    end
    redirect_to root_path
  end
  def show
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
