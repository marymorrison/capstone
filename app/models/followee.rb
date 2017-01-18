class Followee < ApplicationRecord
  belongs_to :user
  belongs_to :peep

  def self.find_or_create_by(uid, pid)
    f = Followee.find_by(user_id: uid, peep_id: pid)
    if f != nil
      return f
    else
      f = Followee.new()
      f.user_id = uid
      f.peep_id = pid
      f.save
      return f
    end
  end
end
