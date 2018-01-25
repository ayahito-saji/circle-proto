module UsersHelper
  def signup_title
    if remember_room_token?
      "Sign up to enter Room #{current_room_token}"
    else
      "Sign up"
    end
  end
end
