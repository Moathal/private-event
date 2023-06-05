class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :attendances
  has_many :users, through: :attendances

  validates :location, presence: true
  validates :date, presence: true
end
