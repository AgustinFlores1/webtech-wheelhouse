class DropRepairServices < ActiveRecord::Migration[8.1]
  def change
    drop_table :repair_services do |t|
      t.decimal :agreed_price, precision: 10, scale: 2, null: false
      t.references :repair, null: false, foreign_key: false
      t.references :service_catalog, null: false, foreign_key: false

      t.timestamps
    end
  end
end
