class HomeController < ApplicationController
  def show
    if !current_user.nil?

      @followers = client.followers
      # @followers = client.followers.take(200)

      # FOLLOWERS:
      @followers.each do |p|
        p.screen_name
        p.id
        Peep.find_or_create_by(p.screen_name, p.id)
      end

      @following = client.friends
      # @following = client.friends.take(200)

      # FOLLOWEES:
      @following.each do |p|
        p.screen_name
        p.id
        Peep.find_or_create_by(p.screen_name, p.id)
      end

      @nonfollowers = @following.to_a - @followers.to_a
      @your_non_followers = @followers.to_a - @following.to_a

    else
    end
  end
end
