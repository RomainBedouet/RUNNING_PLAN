class UsersController < ApplicationController
   before_action :authenticate_user!

  def profile
    @user = current_user
    @objectif = current_user.objectifs.last
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: "Profil mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:age, :weight, :height, :level_running)
  end
end
