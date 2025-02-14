class CreateReceipts < ActiveRecord::Migration[8.0]
  def change
    create_table :receipts do |t|
      t.string :retailer, null: false
      t.date :purchase_date, null: false
      t.time :purchase_time, null: false
      t.integer :total_cents, null: false

      t.timestamps
    end
  end
end
