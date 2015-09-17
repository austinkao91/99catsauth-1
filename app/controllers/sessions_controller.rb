class SessionsController < ApplicationController
  before_action do
    if logged_in?
      if (request.path == "/users/new" ||
          request.path == "/session/new")
          redirect_to cats_url
      end
    end
  end

  def new
    render :new
  end

  def create
    login_user!
  end

  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
