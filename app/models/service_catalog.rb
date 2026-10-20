class ServiceCatalog < ApplicationRecord
  has_many :repair_services, dependent: :restrict_with_error
  has_many :repairs, through: :repair_services, source: :repair

  scope :list_by_name, -> { order(:name) }
  scope :active, -> { where(is_active: true) }

  before_validation :format_service_name

  validates :current_price, presence: true, numericality: { greater_than: 0, less_than: 100_000_000 }
  validates :is_active, inclusion: { in: [ true, false ] }
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  private

  def format_service_name
    self.name = name.strip if name.present?
  end
end
