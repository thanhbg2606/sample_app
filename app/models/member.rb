class Member < ApplicationRecord
  has_one :avatar
  accepts_nested_attributes_for :avatar, update_only: true
end
