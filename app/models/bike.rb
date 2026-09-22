class Bike < ApplicationRecord
  belongs_to :customer
  has_many :repairs, dependent: :restrict_with_error

  scope :list_by_customer, -> { order(:customer_id) }
  scope :list_by_serial, -> { order(:serial_number) }

  before_validation :format_serial_number

  validates :colour, presence: true
  validates :make_model, presence: true
  validates :serial_number, presence: true, uniqueness: true

  private

  def format_serial_number
    self.serial_number = serial_number.strip.upcase if serial_number.present?
  end
end
