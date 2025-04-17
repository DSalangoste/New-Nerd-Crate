ActiveAdmin.register CrateType do
  permit_params :name, :description, :price, category_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column "Categories" do |crate_type|
      crate_type.categories.map(&:name).join(", ")
    end
    column :created_at
    actions
  end

  filter :name
  filter :price
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price, step: :any
      f.input :category_ids, as: :select, collection: Category.all,
              input_html: { multiple: true }, label: "Categories"
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :price
      row "Categories" do |crate_type|
        crate_type.categories.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end
end
