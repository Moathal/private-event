class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :attendances, dependent: :destroy
  has_many :attendees, through: :attendances, source: :user
  
  has_noticed_notifications model_name: 'Notifications'
  has_many :notifications, through: :user, dependent: :destroy

  scope :past_attending_events , -> { where("date < ?", Date.today) }
  scope :future_attending_events, -> { where("date >= ?", Date.today) }

  validates :location, presence: true
  validates :date, presence: true
end
