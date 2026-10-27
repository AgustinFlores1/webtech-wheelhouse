class AddTakenInByToRepairs < ActiveRecord::Migration[8.1]
  def change
    add_reference :repairs, :taken_in_by, foreign_key: { to_table: :users }
  end
end
