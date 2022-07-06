class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: :user, allow_nil: true

  validates :content, presence: true,
  length: {maximum: Settings.micropost.length_content}

  validates :image,
  content_type: {in: Settings.micropost.image_path, message: :wrong_format},
                size: {less_than: Settings.micropost.less_than.megabytes, message: :too_big}

  scope :recent_posts, ->{order created_at: :desc}
  scope :by_users, ->(user_ids){where user_id: user_ids}

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end
