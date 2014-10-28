class SessionsController < ApplicationController
  def new
  end

  def create
    credentials = [
      session_params[:username_or_email], session_params[:password]
    ]

    user = User.find_by_credentials(*credentials)

    if user
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to user_url(user)
    else
      render :new
    end
  end

  def destroy
    session[:session_token] = nil
  end

  private
  def session_params
    params.require(:session).permit(:username_or_email, :password)
  end
end
