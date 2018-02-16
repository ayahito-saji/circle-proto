module EntrancesHelper
  def append_query(url, queries)
    queries.select! {|key, value| !value.blank?}
    if queries.any?
      "#{url}?#{queries.to_query}"
    else
      url
    end
  end

  def enter(room)
    if enter?
      exit
    end
    if (room.users.count < room.maximum || room.maximum == -1 || current_user.premium?) && room.allow_enter?
      current_user.update_attribute(:room_id, room.id)
      current_user.update_attribute(:member_id, room.users.count - 1)
      room.update_attribute(:maximum, -1) if current_user.premium?
      RoomChannel.broadcast_to(current_room,
                        {
                            except: [current_user.member_id],
                            code: members_list_view
                        })
      true
    else
      false
    end
  end
  def enter?
    if !current_room.nil?
      true
    else
      exit if !current_user.room_id.nil?
      false
    end
  end
  def exit
    exit_room = current_room
    current_user.update_attribute(:room_id, nil)
    if !exit_room.nil?
      exit_room.update_attribute(:maximum, 7) if !exit_room.users.where(premium: true).exists?
      if !exit_room.users.exists?
        exit_room.destroy
      elsif !(exit_room.users.count <= exit_room.maximum || exit_room.maximum == -1)
        broadcast_to_room(exit_room, "プレミアムユーザーが抜けたため、この部屋は7人より多い人数で利用できません。", except: [current_user])
        exit_room.users.each do |user|
          user.update_attribute(:room_id, nil)
        end
        exit_room.destroy
      else
        exit_room.users.order(:member_id).each_with_index do |user, i|
          user.update_attribute(:member_id, i)
        end
        RoomChannel.broadcast_to(current_room,
                                 {
                                     except: [current_user.member_id],
                                     code: members_list_view
                                 })
      end
    end
    @current_room = nil
  end
  def current_room
    @current_room ||= Room.find_by(id: current_user.room_id)
  end
  def require_enter
    until enter?
      redirect_to account_path
      return
    end
  end
  def reject_enter
    if enter?
      redirect_to root_path
      return
    end
  end
end
