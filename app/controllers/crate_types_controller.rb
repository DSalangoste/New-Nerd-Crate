class CrateTypesController < ApplicationController
  def show
    @crate_type = CrateType.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Crate type not found"
    redirect_to root_path
  end
end 