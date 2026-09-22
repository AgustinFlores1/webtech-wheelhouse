class StaffMember < ApplicationRecord
  has_many :repairs, foreign_key: "assigned_mechanic_id", dependent: :nullify

  validates :name, presence: true
  validates :role, presence: true
end
