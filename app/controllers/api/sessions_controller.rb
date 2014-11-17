class Api::SessionsController < ApplicationController
  def show
  end

  def create
    credentials = [
      session_params[:username_or_email], session_params[:password]
    ]

    user = User.find_by_credentials(*credentials)

    if user
      login(user)
      redirect_to api_user_url(user)
    else
      render nothing: true, status: :unprocessable_entity
    end
  end

  def destroy
    session[:session_token] = nil
    render nothing: true
  end

  private
  def session_params
    params.require(:session).permit(:username_or_email, :password)
  end
end
