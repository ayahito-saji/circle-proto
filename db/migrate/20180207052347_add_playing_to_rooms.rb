class AddPlayingToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :playing, :boolean, default: false
  end
end
