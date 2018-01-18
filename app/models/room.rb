class Room < ApplicationRecord
  has_many :users, dependent: :destroy
  validates :name, presence: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
end
