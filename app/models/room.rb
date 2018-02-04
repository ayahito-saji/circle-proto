class Room < ApplicationRecord
  attr_accessor :skip_name_uniqueness
  has_secure_password
  has_secure_token
  has_many :users
  validates :name,
            presence: true,
            length: {maximum: 50}
  validates :name, uniqueness: { case_sensitive: false } unless :skip_name_uniqueness
  validates :password,
            presence: true,
            allow_nil: true
end