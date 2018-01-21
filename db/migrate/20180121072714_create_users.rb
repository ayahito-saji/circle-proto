class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :room_id
      t.integer :position
      t.text :var
      t.boolean :actioned?, default: false

      t.timestamps
    end
  end
end
