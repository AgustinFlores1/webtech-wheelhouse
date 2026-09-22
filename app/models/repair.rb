class Repair < ApplicationRecord
  belongs_to :customer
  belongs_to :bike
  belongs_to :assigned_mechanic, optional: true, class_name: "StaffMember"
  has_many :repair_services, dependent: :destroy
  has_many :services, through: :repair_services, source: :service_catalog
end
