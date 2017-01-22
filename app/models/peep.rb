class Peep < ApplicationRecord
  has_many :followers
  has_many :users, through: :followers
  has_many :followees
  has_many :users, through: :followees

  def self.find_or_create_by(screen_name, id, image_url)
    p = Peep.find_by(name: screen_name, uid: id)
    if p != nil
      return p
    else
      p = Peep.new()
      p.name = screen_name
      p.uid = id
      p.image_url = image_url
      p.save
      return p
    end
  end
end
