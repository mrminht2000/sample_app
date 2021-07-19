class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.name.length.max}

  validates :email, presence: true,
    length: {
      minimum: Settings.email.length.min,
      maximum: Settings.email.length.max
    },
    format: {with: Settings.email.valid_regex},
    uniqueness: {case_sensitive: false}

  validates :password, presence: true,
    length: {minimum: Settings.password.length.min},
    if: :password

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
