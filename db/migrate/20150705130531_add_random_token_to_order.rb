class AddRandomTokenToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :random_token, :string
  end
end
