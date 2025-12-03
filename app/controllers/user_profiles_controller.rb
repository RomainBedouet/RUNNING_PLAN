class UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def new
    @user_profile = current_user.user_profile || UserProfile.new
  end

  def create
    @user_profile = UserProfile.new(user_profile_params)
    @user_profile.user = current_user
    if @user_profile.save
      redirect_to root_path, notice: "Profil créé !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user_profile = current_user.user_profile
  end

  def update
    @user_profile = current_user.user_profile
    if @user_profile.update(user_profile_params)
      redirect_to root_path, notice: "Profil mis à jour !"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:weight, :height, :age, :level)
  end
end
