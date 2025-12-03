class UserProfile < ApplicationRecord
  belongs_to :user

  validates :weight, :height, :age, :level, presence: true
  validates :weight, numericality: { greater_than: 20, less_than: 350 }
  validates :height, numericality: { greater_than: 80, less_than: 250 }
  validates :age, numericality: { greater_than: 5, less_than: 120 }
end
