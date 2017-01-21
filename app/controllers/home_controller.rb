class HomeController < ApplicationController

  require 'time_diff'
  require 'date'

  def show
    # if user is signed in
    if !current_user.nil?
      @now = Time.now.utc.to_s
      # Get most recent Follower instance from DB and convert to string
      if Follower.all.count > 0
        @follower_last_update = Follower.all.order('updated_at DESC').first.updated_at.to_s
        # create hash with key datetime, and value of most recent Follower, parsed by date gem
        @follower = {}
        @follower[:datetime_parsed] = DateTime.parse(@follower_last_update)
        @follower[:time_diff_string] = @follower_last_update
      end
      # Get most recent Followee instance from DB and convert to string
      if Followee.all.count > 0
        @followee_last_update = Followee.all.order('updated_at DESC').first.updated_at.to_s
        # create hash with key datetime, and value of most recent Followee, parsed by date gem
        @followee = {}
        @followee[:datetime_parsed] = DateTime.parse(@followee_last_update)
        @followee[:time_diff_string] = @followee_last_update
        # put parsed & most recent Followee and Follower into array and sort on datetime field to find most recent update
      end
      # this if statement and previous 2 will account for any absence of data so no errors occur
      if Followee.all.count > 0 && Follower.all.count > 0
        @list = [@followee, @follower]
        @most_recent_update_time = @list.sort do |a, b|
          a[:datetime_parsed] <=> b[:datetime_parsed]
        end.last

        if @most_recent_update_time == @followee[:datetime_parsed]
          @most_recent = @followee[:time_diff_string]
          @time_diff = Time.diff(Time.parse(@most_recent), Time.parse(@now))
        else
          @most_recent = @follower[:time_diff_string]
          @time_diff = Time.diff(Time.parse(@most_recent), Time.parse(@now))
        end
      elsif Followee.all.count > 0 && Follower.all.count == 0
        @most_recent = @followee[:time_diff_string]
        @time_diff = Time.diff(Time.parse(@most_recent), Time.parse(@now))

      elsif Follower.all.count > 0 && Followee.all.count == 0
        @most_recent = @follower[:time_diff_string]
        @time_diff = Time.diff(Time.parse(@most_recent), Time.parse(@now))
      else
        @time_diff = {}
        @time_diff[:minute] = 1
        @time_diff[:hour] = 1
        @time_diff[:day] = 1
        @time_diff[:week] = 1
        @time_diff[:month] = 1
        @time_diff[:year] = 1
      end

      # if it's been longer than 12 or more hours since last API call
      if @time_diff[:minute] >= 1 || @time_diff[:hour] >= 1 || @time_diff[:day] >= 1 || @time_diff[:week] >= 1 || @time_diff[:month] >= 1 || @time_diff[:year] >= 1

        # API FOLLOWERS:
        @followers_objects = client.followers
        @followers_objects_clone = @followers_objects.dup
        @followers = []
        @followers_objects_clone.each do |peep|
          @followers << peep.screen_name
        end

        @followers_objects_clone.each do |api_data|
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id)
          Follower.find_or_create_by(current_user.id, peep.id)
        end

        # API FOLLOWEES:
        @followees_objects = client.friends
        @followees_objects_clone = @followees_objects.dup
        @followees = []
        @followees_objects_clone.each do |peep|
          @followees << peep.screen_name
        end

        @followees_objects_clone.each do |api_data|
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id)
          Followee.find_or_create_by(current_user.id, peep.id)
        end

        @nonfollowers = @followees.to_a - @followers.to_a
        @your_non_followers = @followers.to_a - @followees.to_a
        @nonfollowers << "API"

      # if it hasn't been longer than 12+ hrs since last API call
      else
        # Get info for current_user from DB
        user = User.find_by(name: current_user.name)

        # DATABASE FOLLOWERS
        user_followers = (Follower.where(user_id: user.id))
        @user_followers_array = []
        user_followers.each do |follower|
          peep_obj = Peep.find_by(id: follower.peep_id)
          @user_followers_array << peep_obj.name
        end
        @followers = @user_followers_array

        # DATABASE FOLLOWEES
        user_followees = (Followee.where(user_id: user.id))
        @user_followees_array = []
        user_followees.each do |followee|
          peep_obj = Peep.find_by(id: followee.peep_id)
          @user_followees_array << peep_obj.name
        end
        @followees = @user_followees_array

        @nonfollowers = @followees.to_a - @followers.to_a
        @your_non_followers = @followers.to_a - @followees.to_a
        @nonfollowers << "DATABASE"
      #
      end
    end
  end

  def unfollow
      client.unfollow(params[:peep_name])
      # Delete nonfollower from DB so update shows immediately
      peep = Peep.find_by(name: params[:peep_name])
      if Followee.find_by(peep_id: peep.id, user_id: current_user.id) != nil
        Followee.find_by(peep_id: peep.id, user_id: current_user.id).destroy
      end
      redirect_to root_path
  end

  def follow
    client.follow(params[:peep_name])
  #   Delete 'follower' from DB so update shows immediately
    peep = Peep.find_by(name: params[:peep_name])
    if Follower.find_by(peep_id: peep.id, user_id: current_user.id) != nil
      Follower.find_by(peep_id: peep.id, user_id: current_user.id).destroy
    end
    redirect_to root_path
  end

end
