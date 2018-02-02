module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end
  def login?
    !session[:user_id].nil? && User.exists?(session[:user_id])
  end
  def logout
    session.delete(:user_id)
    @current_user = nil
  end
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def require_login
    until login?
      redirect_to login_path
      return
    end
  end
  def reject_login
    if login?
      redirect_to root_path
      return
    end
  end

  def login_title
    if remember_room_token?
      "Login to enter Room #{current_room_token}"
    else
      "Login"
    end
  end
end
