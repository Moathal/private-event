class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :events, through: :attendances
    has_many :attendances
    has_many :events, class_name: 'Event', foreign_key: 'creator_id', dependent: :destroy

  validates :fullname, presence: true
  validates :birthday, presence: true
end
