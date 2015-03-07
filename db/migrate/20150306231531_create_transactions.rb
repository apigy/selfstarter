class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :amount
      t.string :card_hash
      t.string :status
      t.references :payment, index: true

      t.timestamps
    end
  end
end
