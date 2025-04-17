class CreateJoinTableCrateTypesCategories < ActiveRecord::Migration[7.1]
  def change
    create_join_table :crate_types, :categories do |t|
      # t.index [:crate_type_id, :category_id]
      # t.index [:category_id, :crate_type_id]
    end
  end
end
