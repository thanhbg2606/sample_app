class Post < ApplicationRecord
  # after_create :validates_empty
  belongs_to :member

  # def validates_empty
  #   raise Exception if title.blank?
  # end
end
