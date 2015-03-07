class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :card_number
      t.string :card_holder_name
      t.string :card_expiration_month
      t.string :card_expiration_year
      t.string :card_cvv
      t.string :card_hash
      t.string :payment_amount

      t.timestamps
    end
  end
end
