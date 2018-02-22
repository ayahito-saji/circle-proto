class Radius
  def Radius.init(current_room, current_user)
    current_room.update_attribute(:play_data, {})
    current_room.users.each do |user|
      user.update_attribute(:play_data, {
          system: {
              phase: 'title'
          }
      })
    end
  end
end