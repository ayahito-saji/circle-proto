class CreateSaveData < ActiveRecord::Migration[5.1]
  def change
    create_table :save_data do |t|
      t.integer :user_id
      t.text :data

      t.timestamps
    end
  end
end
