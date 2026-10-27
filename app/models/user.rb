class User < ApplicationRecord
  PASSWORD_MINIMUM_LENGTH = 10

  has_secure_password
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
end
