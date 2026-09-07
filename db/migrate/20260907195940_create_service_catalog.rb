class CreateServiceCatalog < ActiveRecord::Migration[8.1]
  def change
    create_table :service_catalogs do |t|
      t.string :name, null: false, index: { unique: true }
      t.decimal :current_price, precision: 10, scale: 2, null: false
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
