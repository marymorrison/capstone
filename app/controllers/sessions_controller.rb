class SessionsController < ApplicationController
  def create

    credentials = request.env['omniauth.auth']['credentials']
    session[:access_token] = credentials['token']
    session[:access_token_secret] = credentials['secret']
    # redirect_to root_path, notice: 'Signed in'


    # puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
    # puts env["omniauth.auth"]
    # puts "@@@@@@@@@@@@@@@@@@@@@@@@@"
    #
    user = User.from_omniauth(env["omniauth.auth"])

    # puts "$$$$$$$$$$$$$$$$$$$"
    # puts user
    # puts "$$$$$$$$$$$$$$$$$$$"
    # session[:user_id] = User.from_omniauth(env["omniauth.auth"]).id

    session[:user_id] = user.id
    redirect_to root_path
  end

  # def create
  #   # raise :test
  #   @user = User.find_or_create_from_auth_hash(auth_hash)
  #   self.current_user = @user
  #   redirect_to root_path
  # end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
