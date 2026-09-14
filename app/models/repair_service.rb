class RepairService < ApplicationRecord
  belongs_to :repair
  belongs_to :service_catalog
end
