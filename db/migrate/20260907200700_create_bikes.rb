class CreateBikes < ActiveRecord::Migration[8.1]
  def change
    create_table :bikes do |t|
      t.string :serial_number, null: false, index: { unique: true }
      t.string :make_model, null: false
      t.string :colour, null: false
      t.references :customer, null: false, foreign_key: false

      t.timestamps
    end
  end
end
