class User < ApplicationRecord
  belongs_to :room
  has_secure_password
  validates :password, presence: true
end
