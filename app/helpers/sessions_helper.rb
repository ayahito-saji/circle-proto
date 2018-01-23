module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end
  def login?
    !session[:user_id].nil?
  end
  def logout
    exit
    session.delete(:user_id)
    @current_user = nil
  end
  def current_user
    @current_user ||= User.find(session[:user_id])
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


end
