module SessionsHelper
  def login(user)
    session[:user_id] = user.id
    remember_cookie
  end
  def login?
    !current_user.nil?
  end
  def logout
    forget_cookie
    session.delete(:user_id)
    @current_user = nil
  end
  def remember_cookie
    current_user.remember_token = User.new_token
    current_user.update_attribute(:remember_digest, User.digest(current_user.remember_token))

    cookies.permanent.signed[:user_id] = current_user.id
    cookies.permanent[:remember_token] = current_user.remember_token
  end
  def forget_cookie
    current_user.update_attribute(:remember_digest, nil)
  end
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.cookie_authenticated?(cookies[:remember_token])
        login user
        @current_user = user
      end
    end
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
