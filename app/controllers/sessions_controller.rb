class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:login], params[:password])
    if user
      # session[:user_id] = user.id
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to_target_or_default root_url, :notice => "Logged in as #{user.username}."
    else
      redirect_to login_url, :notice => "Invalid login or password."
    end
  end

  def destroy
    # session[:user_id] = nil
    cookies.delete :auth_token
    redirect_to root_url, :notice => "You have been logged out."
  end
end
