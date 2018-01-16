class RoomsController < ApplicationController
  def new
  end

  def create
    @room = Room.find_by(name: params[:room][:name])
    #ルームが存在しなければ新しく作成する
    if @room.nil?
      @room = Room.new(name: params[:room][:name],
                       maximum: 7,
                       password: params[:room][:password],
                       password_confirmation: params[:room][:password])
      if @room.save
        session[:room] = @room.id
      else
        render "new"
        return
      end
    elsif @room.authenticate(params[:room][:password])
      session[:room] = @room.id
    else
      render "new"
      return
    end

    @user = User.where(room_id: @room.id).find_by(name: params[:user][:name])
    #ユーザーが存在しなければ新しく作成する
    if @user.nil?
      @user = User.new(name: params[:user][:name],
                       room_id: @room.id,
                       password: params[:user][:password],
                       password_confirmation: params[:user][:password])
      if @user.save
        session[:user] = @user.id
      else
        render "new"
        return
      end
    elsif @room.authenticate(params[:room][:password])
      session[:user] = @user.id
    else
      render "new"
      return
    end
  end

  def destroy
  end
end
