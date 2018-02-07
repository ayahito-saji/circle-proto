class AddAllowEnterToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :allow_enter, :boolean, default: true;
  end
end
