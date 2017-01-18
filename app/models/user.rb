# class User < ApplicationRecord
# end
class User < ActiveRecord::Base
  has_many :followers
  has_many :peeps, through: :followers
  has_many :followees
  has_many :peeps, through: :followees


  def self.from_omniauth(auth)
    login_info = self.find_by(provider: auth["provider"], uid: auth["uid"])
    if login_info == nil
      login_info = create_from_omniauth(auth)
    end
    return login_info
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
      user.oauth_token = auth["credentials"]["token"]
      user.oauth_secret = auth["credentials"]["secret"]
    end
  end
end
