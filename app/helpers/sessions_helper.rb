module SessionsHelper
  def login(user_id)
    session[:user_id] = user_id
  end
  def login?
    !session[:user_id].nil?
  end
  def logout
    session[:user_id] = nil
    @current_user = nil
  end
  def current_user
    @current_user ||= User.find(session[:user_id])
  end
end
