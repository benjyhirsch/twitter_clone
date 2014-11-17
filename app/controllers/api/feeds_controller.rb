class Api::FeedsController < ApplicationController
  before_action :ensure_logged_in

  def show
    @tweets = current_user.feed
  end

  private
  def ensure_logged_in
    redirect_to new_session_url unless logged_in?
  end
end
