class ObjectifsController < ApplicationController

  def index
    @objectifs = Objectif.all
  end

  def show
    @objectif = Objectif.find(params[:id])
  end
end
