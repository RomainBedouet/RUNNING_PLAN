class ObjectifsController < ApplicationController

  def index
    @objectifs = Objectif.all
    @objectif = Objectif.new
  end

  def show
    @objectif = Objectif.find(params[:id])
  end

  def create
  @objectif = current_user.objectifs.build(objectif_params)
    if @objectif.save
    redirect_to @objectif
    else
      render :new
    end
  end

private

def objectif_params
  params.require(:objectif).permit(:name)
end

end

