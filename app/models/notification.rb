class Notification < ApplicationRecord
  include Noticed::Model
  belongs_to :recipient, polymorphic: true

  after_create_commit {broadcast_prepend_later_to "notification-user_1", partial: 'layouts/notification', locals: {notification: self, current_user: recipient }, target: 'notifications'}
  # after_update_commit {broadcast_replace_to 'notification', target: 'notification', partial: 'layouts/notification', locals: {notification: self, current_user: recipient }}
  # after_destroy_commit {broadcast_remove_to 'notification', target: 'notification', partial: 'layouts/notification', locals: {notification: self, current_user: recipient }}
end
