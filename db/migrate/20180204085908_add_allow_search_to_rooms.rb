class AddAllowSearchToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :allow_search, :boolean, default: false
  end
end