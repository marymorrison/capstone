class Followee < ApplicationRecord
  belongs_to :user
  belongs_to :peep

  def self.find_or_create_by(uid, pid)
    f = Followee.find_by(user_id: uid, peep_id: pid)
    if f != nil
      f.updated_at = Time.now
      f.save
      # return f
    else
      f = Followee.new()
      f.user_id = uid
      f.peep_id = pid
      f.save
      # return f
    end
    @followee_last_update = Followee.all.order('updated_at DESC').first.updated_at
    Followee.all.each do |followee|
      if followee.updated_at.to_s != @followee_last_update.to_s
        Followee.find(followee.id).destroy
      end
    end

  end
end
