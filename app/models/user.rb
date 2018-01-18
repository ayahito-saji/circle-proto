class User < ApplicationRecord
  belongs_to :room
  validates :name, presence: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
end
