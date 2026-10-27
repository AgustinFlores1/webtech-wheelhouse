class MakeUserEmailUniqueIgnoringCase < ActiveRecord::Migration[8.1]
  def change
    remove_index :users, :email_address, unique: true
    add_index :users, "lower(email_address)", unique: true,
              name: "index_users_on_lower_email_address"
  end
end
