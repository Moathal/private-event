class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { pending: 0, rejected: -1, accepted: 1, canceled: -2 }

  after_update :notify_recipient
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification'

  private

  def notify_recipient
    InviteNotification.with(attendance: self, event: event).deliver_later(user)
  end

  def cleanup_notifications
    notifications_as_attendance.destroy_all
  end
end