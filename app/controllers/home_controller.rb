class HomeController < ApplicationController
  def show
    if !current_user.nil?


      # @followers = client.followers
      @followers = client.followers.take(200)
      # begin
      #   @followers.to_a
      # rescue Twitter::Error::TooManyRequests => error
      #   # NOTE: Your process could go to sleep for up to 15 minutes but if you
      #   # retry any sooner, it will almost certainly fail with the same exception.
      #   sleep error.rate_limit.reset_in + 1
      #   retry
      # end


      # @following = client.friends
      @following = client.friends.take(200)
      # begin
      #   @following.to_a
      # rescue Twitter::Error::TooManyRequests => error
      #   # NOTE: Your process could go to sleep for up to 15 minutes but if you
      #   # retry any sooner, it will almost certainly fail with the same exception.
      #   sleep error.rate_limit.reset_in + 1
      #   retry
      # end

      @nonfollowers = @following.to_a - @followers.to_a
      @your_non_followers = @followers.to_a - @following.to_a

    else
    end
    # @user = client.user(include_entities: true)
  end
end
