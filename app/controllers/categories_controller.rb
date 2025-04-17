class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @crate_types = @category.crate_types
  rescue ActiveRecord::RecordNotFound
    flash[:error] = "Category not found"
    redirect_to categories_path
  end
end 