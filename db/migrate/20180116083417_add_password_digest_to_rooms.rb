class AddPasswordDigestToRooms < ActiveRecord::Migration[5.1]
  def change
    add_column :rooms, :password_digest, :string
  end
end
