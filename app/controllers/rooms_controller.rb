class RoomsController < ApplicationController
  def new
    if login?
      redirect_to room_path
    end
  end

  def create
    @room = Room.find_by(name: params[:room][:name])
    if @room.nil?
      @room = Room.new(name: params[:room][:name],
                       maximum: 7,
                       password: params[:room][:password],
                       password_confirmation: params[:room][:password])
      if @room.save
      else
        flash.now[:danger] = "You failed to create Room '#{params[:room][:name]}'"
        render "new"
        return
      end
    elsif @room.authenticate(params[:room][:password])
    else
      flash.now[:danger] = "Although Room '#{params[:room][:name]}' has already existed, password for the Room is wrong."
      render "new"
      return
    end

    @user = @room.users.find_by(name: params[:user][:name])
    if @user.nil?
      @user = @room.users.build(name: params[:user][:name],
                                password: params[:user][:password],
                                password_confirmation: params[:user][:password])
      if @user.save
      else
        flash.now[:danger] = "You failed to sign in as User '#{params[:user][:name]}'"
        render "new"
        return
      end
    elsif @user.authenticate(params[:user][:password])
    else
      flash.now[:danger] = "Although User '#{params[:user][:name]}' has already been in Room '#{params[:room][:name]}', password for the User is wrong."
      render "new"
      return
    end
    login(@room.id, @user.id)
    flash.now[:success] = "You succeeded to enter Room '#{current_room.name}' as User '#{current_room.name}'."
    redirect_to room_path
  end

  def destroy
    logout
    redirect_to root_path
  end

  def view
    if !login?
      redirect_to root_path
    end
  end
end
