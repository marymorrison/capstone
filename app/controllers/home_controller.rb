class HomeController < ApplicationController

  require 'time_diff'

  def show
    @now = Time.now.utc.to_s
    @last_update = Peep.all.order('updated_at DESC').first.updated_at.to_s
    @time_diff = Time.diff(Time.parse(@last_update), Time.parse(@now))

    if !current_user.nil?
      # if



        @followers = client.followers
        # @followers = client.followers.take(200)

        # FOLLOWERS:
        @followers.each do |api_data|
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id)
          Follower.find_or_create_by(current_user.id, peep.id)
        end

        @following = client.friends
        # @following = client.friends.take(200)

        # FOLLOWEES:
        @following.each do |api_data|
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id)
          Followee.find_or_create_by(current_user.id, peep.id)
        end

        @nonfollowers = @following.to_a - @followers.to_a
        @your_non_followers = @followers.to_a - @following.to_a
      # end
    end
  end
end
