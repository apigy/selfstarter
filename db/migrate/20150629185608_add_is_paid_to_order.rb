class AddIsPaidToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :is_paid, :boolean
  end
end
