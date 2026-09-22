class StaffMember < ApplicationRecord
  has_many :repairs, foreign_key: "assigned_mechanic_id", dependent: :nullify

  scope :list_by_role, -> { order(:role) }

  validates :name, presence: true
  validates :role, presence: true
end
