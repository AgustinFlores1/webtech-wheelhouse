class CreateRepairs < ActiveRecord::Migration[8.1]
  def change
    create_table :repairs do |t|
      t.references :bike, null: false, foreign_key: false
      t.references :customer, null: false, foreign_key: false
      t.references :assigned_mechanic, null: true, foreign_key: false
      t.string :status, null: false, default: "arrived"
      t.text :reported_issue, null: false
      t.decimal :estimated_price, precision: 10, scale: 2
      t.date :promised_return_on, null: false
      t.datetime :closed_at

      t.timestamps
    end
  end
end
