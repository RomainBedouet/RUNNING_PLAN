class Objectif < ApplicationRecord
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :actual_time, numericality: { greater_than: 0}, allow_nil: true
  validates :goal_time, numericality: { greater_than: 0}, allow_nil: true
  validates :km, numericality: { greater_than: 0}, allow_nil: true

end
