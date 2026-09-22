class RepairService < ApplicationRecord
  belongs_to :repair
  belongs_to :service_catalog

  scope :list_by_service_name, -> { joins(:service_catalog).order("service_catalogs.name") }

  validates :agreed_price, presence: true, numericality: { greater_than: 0 }
end
