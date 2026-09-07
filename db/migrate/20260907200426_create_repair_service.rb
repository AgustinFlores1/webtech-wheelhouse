class CreateRepairService < ActiveRecord::Migration[8.1]
  def change
    create_table :repair_services do |t|
      t.references :repair_id, null: false, foreign_key: false
      t.references :service_catalog_id, null: false, foreign_key: false
      t.decimal :agreed_price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
