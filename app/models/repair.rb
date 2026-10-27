class Repair < ApplicationRecord
  INTAKE_PHOTO_TYPES = %w[image/jpeg image/png image/webp].freeze
  INTAKE_PHOTO_MAX_SIZE = 10.megabytes

  belongs_to :customer
  belongs_to :bike
  belongs_to :assigned_mechanic, optional: true, class_name: "StaffMember"
  belongs_to :taken_in_by, optional: true, class_name: "User"

  has_many :repair_services, dependent: :destroy
  has_many :services, through: :repair_services, source: :service_catalog

  has_many_attached :intake_photos, dependent: :purge_later do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 96, 96 ]
    attachable.variant :large, resize_to_limit: [ 600, 600 ]
  end

  has_rich_text :diagnosis

  accepts_nested_attributes_for :repair_services,
    allow_destroy: true,
    reject_if: ->(attrs) { attrs["service_catalog_id"].blank? }

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
  validate :valid_intake_photo

  def overdue?
    closed_at.nil? && promised_return_on < Date.current
  end

  def total
    repair_services.sum(&:agreed_price)
  end

  def customer_answer
    if declined?
      :declined
    elsif approved? || in_progress? || completed? || closed?
      :approved
    end
  end

  private

  def valid_hand_back_time
    if closed_at.present? && created_at.present? && closed_at < created_at
      errors.add(:closed_at, "can't be before the repair's intake date")
    end
  end

  def valid_promised_return_time
    if created_at.present? &&  promised_return_on.present? && created_at.to_date > promised_return_on
      errors.add(:promised_return_on, "date cannot be before the repair is created")
    end
  end

  def valid_change_in_state
    if !arrived? &&  estimated_price.blank?
        errors.add(:estimated_price, "must be set before proceeding to next stages of repair")
    end
  end

  def valid_intake_photo
    intake_photos.reject(&:persisted?).each do |photo|
      unless INTAKE_PHOTO_TYPES.include?(photo.content_type)
        errors.add(:intake_photos, "must be JPEG, PNG or WebP images (#{photo.filename} is not)")
      end

      if photo.byte_size > INTAKE_PHOTO_MAX_SIZE
        errors.add(:intake_photos,
          "must be #{INTAKE_PHOTO_MAX_SIZE / 1.megabyte} MB or smaller each " \
          "(#{photo.filename} is #{ActiveSupport::NumberHelper.number_to_human_size(photo.byte_size)})")
      end
    end
  end
end
