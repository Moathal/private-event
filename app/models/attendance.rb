class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { pending: 0, rejected: -1, accepted: 1, canceled: -2 }

  after_update :notify_recipient
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification'

  private

  def notify_recipient
    notified_user = nil 
    if !saved_change_to_status[0].nil?
      if saved_change_to_status[1] == "cancel" || saved_change_to_status[1] == "pending"
        notified_user = user
      elsif saved_change_to_status[1] == "rejected" || saved_change_to_status[1] == "accepted"
        notified_user = event.creator
      end
      InviteNotification.with(attendance: self, event: event, status: saved_change_to_status[1]).deliver_later(notified_user)
    else
      notified_user = event.creator
      InviteNotification.with(attendance: self, event: event, status: user).deliver_later(notified_user)
    end
  end

  def cleanup_notifications
    notifications_as_attendance.destroy_all
  end
end