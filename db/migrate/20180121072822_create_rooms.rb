class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :token
      t.integer :maximum, default: 7
      t.string :password_digest
      t.text :play_data

      t.timestamps
    end
  end
end
