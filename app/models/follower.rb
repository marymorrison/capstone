class Follower < ApplicationRecord
  belongs_to :user
  belongs_to :peep

  def self.find_or_create_by(uid, pid)
    f = Follower.find_by(user_id: uid, peep_id: pid)
    if f != nil
      f.updated_at = Time.now
      f.save
      # return f
    else
      f = Follower.new()
      f.user_id = uid
      f.peep_id = pid
      f.save
      # return f
    end
    @follower_last_update = Follower.all.order('updated_at DESC').first.updated_at
    Follower.all.each do |follower|
      if follower.updated_at.to_s != @follower_last_update.to_s
        Follower.find(followee.id).destroy
      end
    end


  end
end
