# class User < ApplicationRecord
# end
class User < ActiveRecord::Base
  # def self.from_omniauth(auth)
  #   where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
  #     user.provider = auth.provider
  #     user.uid = auth.uid
  #     user.name = auth.info.name
  #     user.oauth_token = auth.credentials.token
  #     user.oauth_secret = auth.credentials.secret
  #     # user.email = auth.email
  #     user.save!
  #   end
  # end

  def self.from_omniauth(auth)
    login_info = self.find_by(provider: auth["provider"], uid: auth["uid"])
    if login_info == nil
      login_info = create_from_omniauth(auth)
    end
    return login_info
    # where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end
end
