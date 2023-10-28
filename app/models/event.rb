class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'
  has_many :attendances, foreign_key: 'event_id', dependent: :destroy
  has_many :attendees, through: :attendances

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :attendance

  scope :past_attending_events , -> { where("date < ?", Date.today) }
  scope :future_attending_events, -> { where("date >= ?", Date.today) }

  validates :name, presence: true
  validates :location, presence: true
  validates :date, presence: true  

  # Callbacks to trigger the `notify_recipients` method after update and create
  after_update ->(event) { event.notify_recipients(self, 'update', creator, event.attendees_for_sure, id) }
  after_create ->(event) { event.notify_recipients(self, 'create', creator, User.where.not(id: event.creator_id), id) }

  # The method that triggers event_notification  
  def notify_recipients(event, action, creator, recipients, event_id)
    EventNotification.with(event: event, action: action, creator: creator, event_id: event_id).deliver_later(recipients)
  end

  # Returns actual attendees or potential attendees(have 'pending' status in their attendance record).
  def attendees_for_sure
    statuses = %w[accepted pending]
    attendees.where(attendances: { status: statuses })
  end
end
