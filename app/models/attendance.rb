class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { pending: 0, rejected: -1, accepted: 1, canceled: -2 }

  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification'

  # The method that triggers attend_notification.
  def self.notify_recipient(status, event , creator, user, event_id)
    notification = AttendNotification.with(event: event , user: user, creator: creator, status: status, event_id: event_id)
    destination_decider(status, notification, creator, user)
  end

  private

  # Decides which are the recipient of the notification and deliver it.
  def self.destination_decider(status, notification, creator, user)
    case status
    when 'rejected', 'accepted', 'attend', 'cancel_attend'
      notification.deliver_later(creator)
    else 
      notification.deliver_later(user)
    end
  end

  # Clean notifications of the event that has been deleted
  def cleanup_notifications
    notifications_as_attendance.destroy_all
  end
end