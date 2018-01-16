class AddRoomIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :room_id, :integer
  end
end
