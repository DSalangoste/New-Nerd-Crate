module CrateTypesHelper
  def search_results_info(crate_types, search_params)
    if search_params[:search].present? || search_params[:category_id].present?
      category = Category.find_by(id: search_params[:category_id])
      category_text = category ? "in #{category.name}" : "in all categories"
      
      "Found #{crate_types.total_count} #{'result'.pluralize(crate_types.total_count)} " \
      "#{search_params[:search].present? ? "for '#{search_params[:search]}' " : ''}" \
      "#{category_text}"
    end
  end
end 