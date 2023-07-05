class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { pending: 0, rejected: -1, accepted: 1, canceled: -2 }

  after_update :notify_recipient
  after_create :notify_recipient
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification', dependent: :destroy

  private

  def notify_recipient
    notification = InviteNotification.with(attendance: self, event: event, status: saved_change_to_status[1])
    case saved_change_to_status[1]
    when 'canceled', 'pending'
      notification.deliver_later(user)
    else
      notification.deliver_later(event.creator)
    end
  end

  def cleanup_notifications
    notifications_as_attendance.destroy_all
  end
end