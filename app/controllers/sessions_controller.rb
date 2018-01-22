class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: login_params[:email].downcase)
    if !user.nil? && user.authenticate(login_params[:password])
      login user.id
      redirect_to account_path
    else
      flash.now[:danger] = "Login error."
      render 'new'
    end
  end

  def show
  end

  def destroy
  end

  private
    def login_params
      params.require(:session).permit(:email, :password)
    end
end
