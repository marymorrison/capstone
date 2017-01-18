class Peep < ApplicationRecord
  has_many :followers
  has_many :users, through: :followers
  has_many :followees
  has_many :users, through: :followees

  # @followers = client.followers

  def self.followers_from_client(client)
    follower_info = self.find_by(name: client["followers"]["screen_name"])
    if follower_info == nil
      follower_info = create_followers_from_client(client)
    end
    return follower_info
  end

  def self.create_followers_from_client(client)
    create! do |peep|
      peep.name = client["follower"]["screen_name"] # IS THIS RIGHT?
      peep.uid = client["follower"]["id"]
      peep.follower = true
    end
  end
###############################################################

  def self.followees_from_client(client)
    followee_info = self.find_by(name: client["friends"]["screen_name"])
    if followee_info == nil
      followee_info = create_followees_from_client(client)
    end
    return followee_info
  end


  def self.create_followees_from_client(client)
    create! do |peep|
      peep.name = client["friends"]["screen_name"] # IS THIS RIGHT?
      peep.uid = client["friends"]["id"]
      peep.followee = true
    end
  end

end
