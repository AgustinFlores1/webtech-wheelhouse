class Repair < ApplicationRecord
  belongs_to :customer
  belongs_to :bike
  belongs_to :assigned_mechanic, optional: true, class_name: "StaffMember"
  has_many :repair_services, dependent: :destroy
  has_many :services, through: :repair_services, source: :service_catalog

  enum :status, {
    arrived: "arrived",
    pending_approval: "pending_approval",
    approved: "approved",
    declined: "declined",
    in_progress: "in_progress",
    completed: "completed",
    closed: "closed"
  }

  scope :not_returned, -> { where(closed_at: nil) }
  scope :overdue, -> { not_returned.where("promised_return_on < ?", Date.current) }
  scope :list_by_promised_return_on, -> { order(:promised_return_on) }
  scope :list_by_created_at, -> { order(created_at: :desc) }

  validates :estimated_price, numericality: { greater_than: 0, allow_nil: true }
  validates :promised_return_on, presence: true
  validates :status, presence: true
  validates :reported_issue, presence: true

  validate :valid_hand_back_time
  validate :valid_promised_return_time
  validate :valid_change_in_state

  def overdue?
    closed_at.nil? && promised_return_on < Date.current
  end

  def total
    repair_services.sum(&:agreed_price)
  end

  private

  def valid_hand_back_time
    if closed_at.present? && created_at.present? && closed_at < created_at
      errors.add(:closed_at, "can't be before the repair's intake date")
    end
  end

  def valid_promised_return_time
    if created_at.present? && created_at.to_date > promised_return_on
      errors.add(:promised_return_on, "date cannot be before the repair is created")
    end
  end

  def valid_change_in_state
    if !arrived? &&  estimated_price.blank?
        errors.add(:estimated_price, "must be set before proceeding to next stages of repair")
    end
  end
end
