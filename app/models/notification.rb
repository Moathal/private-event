class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit do
    broadcast_prepend_later_to([recipient, 'notifications'],
                               partial: 'layouts/notification',
                               locals: { notification: self },
                               target: 'notifications')
    broadcast_replace_later_to([recipient, 'notificationsCount'],
                               partial: 'layouts/count',
                               locals: { unread_count: unread(recipient).count },
                               target: 'count')
  end

  after_update_commit do
    broadcast_replace_later_to([recipient, 'notifications'],
                               partial: 'layouts/notifications',
                               locals: { notifications: returned_notifications(recipient), unread_count: unread(recipient).count, read_count: read(recipient).count },
                               target: 'notifications')
    broadcast_replace_later_to([recipient, 'notificationsCount'],
                               partial: 'layouts/count',
                               locals: { unread_count: unread(recipient).count },
                               target: 'count')
  end

  def returned_notifications(recipient)
    notifications_unread = recipient.notifications.where(read_at: nil).order(created_at: :desc).reload
    notifications_read = recipient.notifications.where.not(read_at: nil).order(created_at: :desc).limit(9).reload
    (notifications_unread + notifications_read)[0...9]
  end

  def unread(recipient)
    recipient.notifications.where(read_at: nil).reload
  end

  def read(recipient)
    recipient.notifications.where.not(read_at: nil).limit(5).reload
  end
end
