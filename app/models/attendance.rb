class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum status: { pending: 0, rejected: -1, accepted: 1 }
end