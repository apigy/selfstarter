class AddPaymentOptionIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_option_id, :integer
  end
end
