class Peep < ApplicationRecord
  has_many :followers
  has_many :users, through: :followers
  has_many :followees
  has_many :users, through: :followees
end
