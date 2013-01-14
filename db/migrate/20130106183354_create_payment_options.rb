class CreatePaymentOptions < ActiveRecord::Migration
  def change
    create_table :payment_options do |t|
      t.decimal :amount
      t.string :amount_display
      t.text :description
      t.string :shipping_desc
      t.string :delivery_desc
      t.integer :limit

      t.timestamps
    end
  end
end
