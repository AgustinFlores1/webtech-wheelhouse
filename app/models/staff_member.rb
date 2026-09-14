class StaffMember < ApplicationRecord
  has_many :repairs, foreign_key: "assigned_mechanic_id"
end
