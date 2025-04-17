class CrateTypesController < ApplicationController
  def index
    @crate_types = CrateType.page(params[:page]).per(12)  # Show 12 items per page
  end

  def show
    @crate_type = CrateType.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Crate type not found"
    redirect_to root_path
  end
end 