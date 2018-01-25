class UsersController < ApplicationController
  before_action :reject_login, only: [:new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login@user
      if remember_room_token?
        redirect_to enter_path
      else
        redirect_to root_path
      end
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end