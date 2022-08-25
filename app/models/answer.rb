class Answer < ApplicationRecord
  # after_create :validates_empty
  belongs_to :question

  # def validates_empty
  #   raise Exception if content.blank?
  # end
end
