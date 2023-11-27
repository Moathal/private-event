# frozen_string_literal: true

# This class represents an attendance record for each attendee in an event it notifies host and attendees if any update occurs to it.
class Attendance < ApplicationRecord
  belongs_to :event, foreign_key: 'event_id'
  belongs_to :attendee, class_name: 'User', foreign_key: 'attendee_id'
  belongs_to :host, class_name: 'User', foreign_key: 'host_id'
  enum status: { pending: 0, rejected: -1, accepted: 1, canceled: -2 }

  has_noticed_notifications model_name: 'Notification'

  before_destroy :cleanup_notifications

  after_commit do
    attendance = destroyed? ? nil : self
    creator = event.creator.nil? ? nil : event.creator
    attending_users_attendances = Attendance.where('status >= ? AND event_id = ? ', 0, event_id).reload
    attending_ids = attending_users_attendances.pluck(:attendee_id) + [creator.id]
    unattending_users = User.where.not(id: attending_ids).reload

    User.all.each do |user|
      broadcast_replace_to([event, "#{user.id}-attendance"],
                           partial: 'events/attendances',
                           locals: { event:,
                                     creator:,
                                     attendances: attending_users_attendances,
                                     attend: attendance,
                                     unattending_users: unattending_users,
                                     logged_in_user: user },
                           target: 'attendances')
    end
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

  # Clean notifications of the event that has been deleted
  def cleanup_notifications
    notifications_as_attendance.destroy_all
  end
end
