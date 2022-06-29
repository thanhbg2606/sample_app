class User < ApplicationRecord
  USER_ATTRS = %w(name email password password_confirmation).freeze

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

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
