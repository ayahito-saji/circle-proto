module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :cuser, :croom
    def connect
      self.cuser = find_verified_user
      self.croom = find_verified_room
    end

    protected
    def find_verified_user
      if verified_user = User.find_by(id: session['user_id'])
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def find_verified_room
      if verified_room = Room.find_by(id: cuser.room_id)
        verified_room
      else
        reject_unauthorized_connection
      end
    end

    def session
      cookies.encrypted[Rails.application.config.session_options[:key]]
    end
  end
end
