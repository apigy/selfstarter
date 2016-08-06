class ChangeUserIdToInteger < ActiveRecord::Migration
  def change
    change_column :orders, :user_id, :integer
  end
end
