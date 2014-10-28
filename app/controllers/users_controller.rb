class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_url(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_url(@user)
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to
    else

    end
  end

  private
  def user_params
    params.require(:user).permit(
      :full_name, :username, :email, :password, :location, :website
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_current_user
    redirect_to root_url unless logged_in? && current_user.id == @user.id
  end
end
