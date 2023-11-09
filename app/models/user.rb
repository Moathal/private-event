# frozen_string_literal: true

# the HOST or event creator and also can be event attendee. devise is used for authentication 
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :attendances, class_name: 'Attendance', foreign_key: 'attendee_id'
  has_many :attended_events, through: :attendances, source: :event

  has_many :events_as_host, class_name: 'Attendance', foreign_key: 'host_id'
  has_many :hosted_events, through: :events_as_host, source: :event

  has_many :events, class_name: 'Event', foreign_key: 'creator_id', dependent: :destroy

  has_many :notifications, as: :recipient, dependent: :destroy

  validates :fullname, presence: true
  validates :birthday, presence: true
end
