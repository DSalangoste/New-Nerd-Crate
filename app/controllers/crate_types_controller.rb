class CrateTypesController < ApplicationController
  def index
    @crate_types = CrateType.search(search_params)
                           .page(params[:page])
                           .per(12)
  end

  def show
    @crate_type = CrateType.includes(:categories).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Crate type not found"
    redirect_to root_path
  end

  private

  def search_params
    params.permit(:search, :category_id)
  end
end 