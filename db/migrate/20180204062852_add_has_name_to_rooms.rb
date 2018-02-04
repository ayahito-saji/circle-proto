class AddHasNameToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :has_name, :boolean, default: false
  end
end
