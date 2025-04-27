class UpdateCategoriesCrateTypesJoinTable < ActiveRecord::Migration[7.1]
  def change
    # Drop existing indexes if they exist
    remove_index :categories_crate_types, [:category_id, :crate_type_id], if_exists: true
    remove_index :categories_crate_types, :crate_type_id, if_exists: true

    # Drop existing foreign keys if they exist
    remove_foreign_key :categories_crate_types, :categories, if_exists: true
    remove_foreign_key :categories_crate_types, :crate_types, if_exists: true

    # Add indexes and foreign keys with cascade delete
    add_index :categories_crate_types, [:category_id, :crate_type_id], unique: true
    add_index :categories_crate_types, :crate_type_id
    add_foreign_key :categories_crate_types, :categories, on_delete: :cascade
    add_foreign_key :categories_crate_types, :crate_types, on_delete: :cascade
  end
end
