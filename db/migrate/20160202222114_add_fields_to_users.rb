class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :stripe_charge_id, :string
    add_column :users, :api_order_id, :string
    add_column :users, :order_data, :json, default: {}
  end
end
