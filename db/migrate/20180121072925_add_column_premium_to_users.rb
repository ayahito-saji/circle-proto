class AddColumnPremiumToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :premium?, :boolean
  end
end
