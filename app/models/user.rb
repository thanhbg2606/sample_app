class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
            foreign_key: "follower_id",
            dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
            foreign_key: "followed_id",
            dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  attr_accessor :remember_token, :activation_token, :reset_token
  USER_ATTRS = %w(name email password password_confirmation).freeze


  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
            foreign_key: :follower_id,
            dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
            foreign_key: :followed_id,
            dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true,
            length: {maximum: Settings.user.name.max_length}

  validates :email, presence: true,
            length: {maximum: Settings.user.email.max_length},
            format: {with: Settings.user.email_regex},
            uniqueness: true

  validates :password, presence: true,
            length: {minimum: Settings.user.password.min_length}, if: :password,
            allow_nil: true

  before_save :downcase_email
  before_create :create_activation_digest

  scope :asc_name_user, ->{order name: :asc}
  scope :recent_posts, ->{order created_at: :desc}

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

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.user.time_password_expired.hours.ago
  end

  def feed
    Micropost.by_user_ids following_ids << id
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
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
