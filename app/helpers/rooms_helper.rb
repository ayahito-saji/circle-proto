module RoomsHelper
  def send_current_room_to_front
    gon.current_room = {
        users: current_room.users.order(:member_id).map { |member|
          {
              id: member.id,
              name: member.name,
              is_premium: member.premium?
          }
        },
        name: current_room.name,
        password: current_room.password,
        allow_search: current_room.allow_search?,
        maximum: current_room.maximum,
        var: current_room.var
    }
  end
end
