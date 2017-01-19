class HomeController < ApplicationController

  require 'time_diff'

  def show
    @now = Time.now.utc.to_s
    @last_update = Peep.all.order('updated_at DESC').first.updated_at.to_s
    @time_diff = Time.diff(Time.parse(@last_update), Time.parse(@now))

    # if user is signed in
    if !current_user.nil?
      # if it's been longer than 12 or more hours since last API call
      if @time_diff[:hour] >= 0 || @time_diff[:day] > 0 || @time_diff[:week] > 0 || @time_diff[:month] > 0 || @time_diff[:year] > 0

        # API FOLLOWERS:
        @followers_objects = client.followers
        @followers = []
        @followers_objects.each do |peep|
          @followers << peep.screen_name
        end
        # @followers = client.followers.take(200)
        @followers_objects.each do |api_data|
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id)
          Follower.find_or_create_by(current_user.id, peep.id)
        end

        # API FOLLOWEES:
        @followees_objects = client.friends
        @followees = []
        @followees_objects.each do |peep|
          @followees << peep.screen_name
        end

        # @followees = client.friends.take(200)
        @followees_objects.each do |api_data|
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id)
          Followee.find_or_create_by(current_user.id, peep.id)
        end

        @nonfollowers = @followees.to_a - @followers.to_a
        @your_non_followers = @followers.to_a - @followees.to_a
      # if it hasn't been longer than 12+ hrs since last API call
      else
        # Get info for current_user from DB
        user = User.find_by(name: current_user.name)
        # DATABASE FOLLOWERS
        user_follower_objects = Follower.where(user_id: user.id)
        @user_followers_array = []
        user_follower_objects.each do |follower_obj|
          peep_obj = Peep.find_by(id: follower_obj.peep_id)
          @user_followers_array << peep_obj.name
        end
        @followers = @user_followers_array

        # DATABASE FOLLOWEES
        user_followee_objects = Followee.where(user_id: user.id)
        @user_followees_array = []
        user_followee_objects.each do |followee_obj|
          peep_obj = Peep.find_by(id: followee_obj.peep_id)
          @user_followees_array << peep_obj.name
        end
        @followees = @user_followees_array

        @nonfollowers = @followees.to_a - @followers.to_a
        @your_non_followers = @followers.to_a - @followees.to_a
      #
      end
    end
  end
end
