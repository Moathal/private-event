# frozen_string_literal: true

# Held by a user(creator) at specific date & time.
# can be attended by multiple users(attendees) weather by inviting or simple attend.
# Can be private and public. It auto notify attendees for any updates to it.
class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :attendances, foreign_key: 'event_id', dependent: :destroy
  has_many :attendees, through: :attendances

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :attendance, dependent: :destroy

  scope :past_attending_events, -> { where('date < ?', Date.today) }
  scope :future_attending_events, -> { where('date >= ?', Date.today) }

  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true

  # Callbacks to trigger the `notify_recipients` method after update and create
  after_update ->(event) { event.notify_recipients(self, 'update', creator, event.attendees_for_sure, id) }
  after_create ->(event) { event.notify_recipients(self, 'create', creator, User.where.not(id: event.creator_id), id) }
  after_destroy :cleanup_notifications

  # The method that triggers event_notification
  def notify_recipients(event, action, creator, recipients, event_id)
    EventNotification.with(event:, action:, creator:, event_id:).deliver_later(recipients)
  end

  # Returns actual attendees or potential attendees(have 'pending' status in their attendance record).
  def attendees_for_sure
    statuses = %w[accepted pending]
    attendees.where(attendances: { status: statuses })
  end

  def cleanup_notifications
    notifications_as_event.destroy_all
  end
end
