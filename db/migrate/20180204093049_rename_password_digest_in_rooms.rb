class RenamePasswordDigestInRooms < ActiveRecord::Migration[5.1]
  def change
    rename_column :rooms, :password_digest, :password
  end
end
