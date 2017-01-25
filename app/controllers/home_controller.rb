class HomeController < ApplicationController

  require 'time_diff'
  require 'date'

  def show
    # CONFIRM USER IS SIGNED IN
    @current_uri = request.env['PATH_INFO']
    if !current_user.nil?
      @current_user_image ||= User.find(session[:user_id]).image_url if session[:user_id]
      @current_time = Time.now.utc.to_s
      # GET MOST RECENT FOLLOWER & FOLLOWEE UPDATED_AT TIME FROM DB
      # PARSE MOST RECENT FOLLOWER & FOLLOWEE UPDATED_AT W/ DATE GEM & STRINGIFY
      # BOTH KEYS NEEDED - ONE FOR SORTING, ONE FOR TIME_DIFF GEM COMPARISON

      if Follower.all.count > 0
        @follower = {
          "datetime_parsed" => DateTime.parse(Follower.all.order('updated_at DESC').first.updated_at.to_s),
          "time_diff_string" => Follower.all.order('updated_at DESC').first.updated_at.to_s
        }
      end

      if Followee.all.count > 0
        @followee = {
          "datetime_parsed" => DateTime.parse(Followee.all.order('updated_at DESC').first.updated_at.to_s),
          "time_diff_string" => Followee.all.order('updated_at DESC').first.updated_at.to_s
        }
      end

      # HANDLES ABSENCE OF DATA FROM FOLLOWER, FOLLOWEE, OR BOTH ~ RESCUE OF SORTS
      if Followee.all.count > 0 && Follower.all.count > 0
        @last_update = [@followee["datetime_parsed"], @follower["datetime_parsed"]].sort.last
        if @last_update == @followee["datetime_parsed"]
          @most_recent = @followee["time_diff_string"]
        else
          @most_recent = @follower["time_diff_string"]
        end
      elsif Followee.all.count > 0 && Follower.all.count == 0
        @most_recent = @followee["time_diff_string"]
      elsif Follower.all.count > 0 && Followee.all.count == 0
        @most_recent = @follower["time_diff_string"]
      end

      if Followee.all.count != 0 || Follower.all.count != 0
        @time_diff = Time.diff(Time.parse(@most_recent), Time.parse(@current_time))
      else
        @time_diff = {
          minute: 1,
          hour: 1,
          day: 1,
          week: 1,
          month: 1,
          year: 1
        }
      end

      # TIME SETTING FOR API CALLS, OTHERWISE USE DB
      if (@time_diff[:minute] >= 1 || @time_diff[:hour] >= 1 || @time_diff[:day] >= 1 || @time_diff[:week] >= 1 || @time_diff[:month] >= 1 || @time_diff[:year] >= 1)

        # API FOLLOWERS:
        @followers = []
        @followers_images = []
        @api_followers = client.followers
        @api_followers.each do |api_data|
          @followers << api_data.screen_name
          @followers_images << api_data.profile_image_url_https
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id, api_data.profile_image_url_https)
          Follower.find_or_create_by(current_user.id, peep.id)
        end
        # API FOLLOWEES:
        @followees = []
        @followees_images = []
        @api_followees = client.friends
        @api_followees.each do |api_data|
          @followees << api_data.screen_name
          @followees_images << api_data.profile_image_url_https
          peep = Peep.find_or_create_by(api_data.screen_name, api_data.id, api_data.profile_image_url_https)
          Followee.find_or_create_by(current_user.id, peep.id)
        end
        # WHERE DATA IS COMING FROM
        @data_origin = "API"
      else
      # DATABASE
      # USER IS NOT NEW & IF API HAS BEEN CALLED RECENTLY
        user = User.find_by(name: current_user.name)

        # DATABASE FOLLOWERS
        @user_followers = (Follower.where(user_id: user.id))
        @followers = []
        @followers_images = []
        @user_followers.each do |db_data|
          peep_obj = Peep.find_by(id: db_data.peep_id)
          @followers << peep_obj.name
          @followers_images << peep_obj.image_url
        end
        # DATABASE FOLLOWEES
        @user_followees = (Followee.where(user_id: user.id))
        @followees = []
        @followees_images = []
        @user_followees.each do |db_data|
          peep_obj = Peep.find_by(id: db_data.peep_id)
          @followees << peep_obj.name
          @followees_images << peep_obj.image_url
        end
        # WHERE DATA IS COMING FROM
        @data_origin = "DATABASE"
      end

      # GOLDEN F/F RATE AND FOLLOWERS/FOLLOWING COUNT:
      @total_followers = @followers_images.length
      @total_following = @followees_images.length
      if @followees_images.length > 0 && @followers_images.length > 0
        @golden_rate = ((@followers_images.length * 1.0) / @followees_images.length).round(2)
      end

      # DETERMINE RUDE PPL & GROUPIES
      @nonfollowers = @followees - @followers
      @nonfollowers_images = @followees_images - @followers_images
      @groupies = @followers - @followees
      @groupies_images = @followers_images - @followees_images

      @nonfollowers_names_and_images = []
      @groupies_names_and_images = []

      if @nonfollowers.length != nil
        @nonfollowers.length.times do |i|
          @nonfollowers_names_and_images << [@nonfollowers[i], @nonfollowers_images[i]]
        end
      end

      if @groupies.length != nil
        @groupies.length.times do |i|
          @groupies_names_and_images << [@groupies[i], @groupies_images[i]]
        end
      end
    end
  end

  def unfollow
      client.unfollow(params[:peep_name])
      # DELETE NONFOLLOWER FROM DB SO UPDATES IMMEDIATELY
      peep = Peep.find_by(name: params[:peep_name])
      if Followee.find_by(peep_id: peep.id, user_id: current_user.id) != nil
        Followee.find_by(peep_id: peep.id, user_id: current_user.id).destroy
      end
      redirect_to root_path
  end

  def follow
    client.follow(params[:peep_name])
    # DELETE FOLLOWER FROM DB SO UPDATES IMMEDIATELY
    peep = Peep.find_by(name: params[:peep_name])
    if Follower.find_by(peep_id: peep.id, user_id: current_user.id) != nil
      Follower.find_by(peep_id: peep.id, user_id: current_user.id).destroy
    end
    redirect_to root_path
  end
end
