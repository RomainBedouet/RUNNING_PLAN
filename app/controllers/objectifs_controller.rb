class ObjectifsController < ApplicationController

  def index
    @objectifs = Objectif.all
    @objectif = Objectif.new
  end

  def show
    @objectif = Objectif.find(params[:id])
    @user = current_user
  end

  def new
    @objectif = Objectif.new
  end

  def create
    @objectif = current_user.objectifs.new(objectif_params)
    if @objectif.save
      redirect_to objectif_path(@objectif), notice: "Objectif créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @objectif = current_user.objectifs.find(params[:id])

    if @objectif.update(objectif_params)
      redirect_to objectif_path(@objectif), notice: "Objectif mis à jour avec succès."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def objectif_params
    params.require(:objectif).permit(:name, :actual_time, :goal_time, :km)
  end
  
end

def requires_km?
  name == "Courir un 10km" 
end
