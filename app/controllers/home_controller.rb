class HomeController < ApplicationController
  def show
    if !current_user.nil?
      @followers = client.followers
      @following = client.friends
      @user = client.user
    else
    end
    # @user = client.user(include_entities: true)
  end
end
