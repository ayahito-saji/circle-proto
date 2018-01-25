class SessionsController < ApplicationController
  before_action :reject_login, only: [:new, :create]
  before_action :require_login, only: [:show, :destroy]
  def new
  end

  def create
    user = User.find_by(email: login_params[:email].downcase)
    if !user.nil? && user.authenticate(login_params[:password])
      login user
      if remember_room_token?
        redirect_to enter_path
      else
        redirect_to root_path
      end
    else
      flash.now[:danger] = "Login error."
      render 'new'
    end
  end

  def show
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def login_params
    params.require(:session).permit(:email, :password)
  end

end
