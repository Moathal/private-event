class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit do
    broadcast_prepend_later_to([self.recipient, "notifications"],
     partial: 'layouts/notification',
      locals: {notification: self, current_user: recipient },
      target: 'notifications')
    broadcast_replace_later_to([self.recipient, "notificationsCount"],
      partial: 'layouts/count',
      locals: {count: Notification.where(read_at: nil, recipient: self.recipient).count, current_user: recipient },
      target: 'count')
  end

  
  after_update_commit do
    puts 'The call_back is called'
    broadcast_replace_later_to([self.recipient, "notifications"],
     partial: 'layouts/notification',
      locals: {notification: self, current_user: recipient },
      target: 'notifications')
    broadcast_replace_later_to([self.recipient, "notificationsCount"],
     partial: 'layouts/count',
      locals: {count: Notification.where(read_at: nil, recipient: self.recipient).count, current_user: recipient },
      target: 'count')
  end
end
