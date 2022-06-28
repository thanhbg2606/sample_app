class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: Settings.user.email_regex},
            uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.user.password.min_length}, if: :password

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
