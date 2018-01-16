class Room < ApplicationRecord
  validates :name, presence: true
  has_secure_password
  validates :password, presence: true
end
