class CreatePaymentServices < ActiveRecord::Migration
  def change
    create_table :payment_services do |t|
      t.string :name

      t.timestamps
    end
  end
end
