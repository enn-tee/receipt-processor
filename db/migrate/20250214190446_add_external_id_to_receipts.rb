class AddExternalIdToReceipts < ActiveRecord::Migration[8.0]
  def change
    add_column :receipts, :external_id, :string
    add_index :receipts, :external_id, unique: true
  end
end
