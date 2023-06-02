class User < ApplicationRecord
    has_many :events, through: :attendances
    has_many :attendances
    has_many :created_events, class_name: 'Event', foreign_key: 'user_id'

  validates :fullname, presence: true
  validates :fullname, presence: true
end
