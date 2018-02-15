module UsersHelper
  def send_current_user_to_front
    gon.current_user = {
        member_id: current_user.member_id,
        var: current_user.var,
        actioned: current_user.actioned
    }
  end
end
