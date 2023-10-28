class Attendance < ApplicationRecord
  belongs_to :event, foreign_key: 'event_id'
  belongs_to :attendee, class_name: 'User', foreign_key: 'attendee_id'
  belongs_to :host, class_name: 'User', foreign_key: 'host_id'
  enum status: { pending: 0, rejected: -1, accepted: 1, canceled: -2 }

  has_noticed_notifications model_name: 'Notification'

  # before_destroy :cleanup_notifications

  after_commit do
    attending_users = event.attendees.where('status >= ?', 0) + [event.creator]
    attending_ids = attending_users.pluck(:id)
    unattending_users = User.where.not(id: attending_ids)
    attending_user = self

    broadcast_replace_later_to([event, 'attendance'],
                               partial: 'events/_attendances',
                               locals: { event:,
                                         creator: event.creator,
                                         attendances: attending_user,
                                         attend: attending,
                                         unattending_users: },
                               target: 'attendances')
  end

  # The method that triggers attend_notification.
  def self.notify_recipient(status, event, creator, user, event_id)
    notification = AttendNotification.with(event:, user:, creator:, status:,
                                           event_id:)
    destination_decider(status, notification, creator, user)
  end

  # Decides which are the recipient of the notification and deliver it.
  def self.destination_decider(status, notification, creator, user)
    case status
    when 'rejected', 'accepted', 'attend', 'cancel_attend'
      notification.deliver_later(creator)
    else
      notification.deliver_later(user)
    end
  end
  
  private

  # def attending(user)
  #   user.attendances.find_by(event_id: event.id)
  # end

  # Clean notifications of the event that has been deleted
  # def cleanup_notifications
  #   notifications_as_attendance.destroy_all
  # end

  # def unattending_users
  #   return if event.nil?

  #   attending_users = event.attendees.where('status >= ?', 0) + [event.creator]
  #   attending_ids = attending_users.pluck(:id)
  #   User.where.not(id: attending_ids)
  # end
end
