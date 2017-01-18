class Followee < ApplicationRecord
  belongs_to :user
  belongs_to :peep
end
