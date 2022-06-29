class Question < ApplicationRecord
  has_many :answers
  accepts_nested_attributes_for :answers,
                                reject_if: :reject_answers,
                                allow_destroy: true,
                                limit: 4

  private

  def reject_answers(attributes)
    attributes['content'].blank?
  end
end
