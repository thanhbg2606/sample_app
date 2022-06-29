class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  scope :asc_name_user, ->{order(name: :asc)}

  USER_ATTRS = %w(name email password password_confirmation).freeze

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true,
            length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: Settings.user.email_regex},
            uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.user.password.min_length}, if: :password,
            allow_nil: true

  has_secure_password

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.blank?

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
