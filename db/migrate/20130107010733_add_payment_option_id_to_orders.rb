class AddPaymentOptionIdToOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :orders, :payment_option_id, :integer
  end
end
