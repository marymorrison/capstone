class FaqsController < ApplicationController

  helper_method :current_user
  helper_method :current_user_image
  helper_method :current_uri

  def show
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user_image ||= User.find(session[:user_id]).image_url if session[:user_id]
    @current_uri = request.env['PATH_INFO']
  end

end
