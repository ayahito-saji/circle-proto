module UsersHelper
  def signup_title
    if remember_room_token?
      "Sign up to enter Room #{current_room_token}"
    else
      "Sign up"
    end
  end
  def icon_for(user, size: 80)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name)
  end
end
