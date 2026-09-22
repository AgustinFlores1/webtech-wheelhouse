class Bike < ApplicationRecord
  belongs_to :customer
  has_many :repairs, dependent: :restrict_with_error

  scope :list_by_cutomer, -> { order(:customer_id) }
  scope :list_by_serial, -> { order(:serial_number) }

  validates :colour, presence: true
  validates :make_model, presence: true
  validates :serial_number, presence: true, uniqueness: true
end
