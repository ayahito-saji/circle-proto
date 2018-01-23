class Room < ApplicationRecord
  has_secure_token
  has_many :users
end