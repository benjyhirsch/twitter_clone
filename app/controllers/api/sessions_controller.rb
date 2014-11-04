class SessionsController < ApplicationController
  def new
  end

  def create
    credentials = [
      session_params[:username_or_email], session_params[:password]
    ]

    user = User.find_by_credentials(*credentials)

    if user
      login(user)
      redirect_to root_url
    else
      render :new
    end
  end

  def destroy
    session[:session_token] = nil
    redirect_to new_session_url
  end

  private
  def session_params
    params.require(:session).permit(:username_or_email, :password)
  end
end
