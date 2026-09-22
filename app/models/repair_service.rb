class RepairService < ApplicationRecord
  belongs_to :repair
  belongs_to :service_catalog

  validates :agreed_price, presence: true, numericality: { greater_than: 0 }
end
