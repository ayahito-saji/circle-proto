class RoomsController < ApplicationController
  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
    else
      render 'new'
    end
  end

  def destroy
  end

  private
    def room_params
      params.require(:room).permit(:name, :maximum)
    end
end
