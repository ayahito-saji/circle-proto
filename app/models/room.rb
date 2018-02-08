class Room < ApplicationRecord
  attr_accessor :skip_search_validation
  serialize :var, Hash
  has_secure_token
  has_many :users
  validates :name,
            length: {maximum: 50}
  validates :name, presence: true, uniqueness: { case_sensitive: false }, unless: :skip_search_validation
  validates :password, presence: true, unless: :skip_search_validation
end