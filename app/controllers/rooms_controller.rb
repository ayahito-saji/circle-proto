class RoomsController < ApplicationController
  def new
  end

  def create
    @room = Room.new
    @room.name = params[:room][:name]
    @room.maximum = 8

    @user = User.new
    @user.name = params[:user][:name]

    if @room.save
    else
      render 'new'
    end
  end

  def destroy
  end
end
