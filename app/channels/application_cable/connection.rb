module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user, :current_room
    def connect
      self.current_user = find_verified_user
      self.current_room = find_verified_room
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
      if verified_room = Room.find_by(id: current_user.room_id)
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
