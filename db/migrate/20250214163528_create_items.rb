class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :short_description, null: false
      t.integer :price_cents, null: false
      t.references :receipt, null: false, foreign_key: true

      t.timestamps
    end
  end
end
