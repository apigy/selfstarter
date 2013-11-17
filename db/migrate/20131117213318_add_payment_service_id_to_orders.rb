class AddPaymentServiceIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_service_id, :integer
  end
end
