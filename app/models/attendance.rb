class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  belongs_to :invited_user, class_name: "User", optional: true
  enum status: { pending: 0, rejected: -1, accepted: 1 }
end