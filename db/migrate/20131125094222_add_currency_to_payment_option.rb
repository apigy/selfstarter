class AddCurrencyToPaymentOption < ActiveRecord::Migration
  def change
    add_column :payment_options, :currency, :string
  end
end
