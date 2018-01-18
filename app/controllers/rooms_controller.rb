class RoomsController < ApplicationController
  before_action :require_login, only:[:view]
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
      if @room.invalid?
        flash.now[:danger] = "You failed to create Room '#{params[:room][:name]}'. #{@room.errors.messages}"
        render "new"
        return
      end
    elsif !@room.authenticate(params[:room][:password])
      flash.now[:danger] = "Although Room '#{params[:room][:name]}' has already existed, password for the Room is wrong."
      render "new"
      return
    end

    @user = @room.users.find_by(name: params[:user][:name])
    if @user.nil?
      if @room.users.count < @room.maximum
        @user = @room.users.build(name: params[:user][:name],
                                  password: params[:user][:password],
                                  password_confirmation: params[:user][:password])
        if @user.invalid?
          flash.now[:danger] = "You failed to sign in as User '#{params[:user][:name]}'. #{@user.errors.messages}"
          render "new"
          return
        end
      else
        flash.now[:danger] = "Room '#{params[:room][:name]}' is full of members"
        render "new"
        return
      end
    elsif !@user.authenticate(params[:user][:password])
      flash.now[:danger] = "Although User '#{params[:user][:name]}' has already been in Room '#{params[:room][:name]}', password for the User is wrong."
      render "new"
      return
    end

    ActiveRecord::Base.transaction do
      @room.save! if @room.new_record?
      @user.save! if @user.new_record?
    end
    login(@room.id, @user.id)
    flash[:success] = "You succeeded to enter Room '#{current_room.name}' as User '#{current_room.name}'."
    redirect_to room_path
    rescue
      flash.now[:danger] = "Database Error"
      render "new"
  end

  def destroy
    current_room.destroy
    logout
    redirect_to root_path
  end

  def exit
    logout
    redirect_to root_path
  end

  def view
  end

  private
    def require_login
      unless login? && Room.exists?(session[:room_id])
        redirect_to root_path
        return
      end
    end
end
