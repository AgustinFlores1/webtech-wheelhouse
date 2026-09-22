class ServiceCatalog < ApplicationRecord
  has_many :repair_services, dependent: :restrict_with_error
  has_many :repairs, through: :repair_services, source: :repair

  validates :current_price, presence: true, numericality: { greater_than: 0 }
  validates :is_active, inclusion: { in: [ true, false ] }
  validates :name, presence: true, uniqueness: true
end
