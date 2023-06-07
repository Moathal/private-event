class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, sources: :user

  validates :location, presence: true
  validates :date, presence: true
end
