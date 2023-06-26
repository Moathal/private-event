class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    
    has_many :attendances
    has_many :attended_events, through: :attendances, source: :event
    has_many :events, class_name: 'Event', foreign_key: 'creator_id', dependent: :destroy
    has_many :notifications, as: :recipient, dependent: :destroy

  validates :fullname, presence: true
  validates :birthday, presence: true
end
