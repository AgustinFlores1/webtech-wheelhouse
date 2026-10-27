class User < ApplicationRecord
  PASSWORD_MINIMUM_LENGTH = 10

  has_secure_password

  has_many :repairs_taken_in, class_name: "Repair", foreign_key: :taken_in_by_id, inverse_of: :taken_in_by, dependent: :restrict_with_error
  has_many :sessions, dependent: :destroy

  belongs_to :staff_member, optional: true

  enum :role, {
    owner: "owner",
    mechanic: "mechanic",
    counter: "counter"
  },
  validate: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: PASSWORD_MINIMUM_LENGTH }, allow_nil: true
  validates :staff_member_id, uniqueness: true, allow_nil: true

  def display_name
    staff_member&.name || email_address
  end
end
