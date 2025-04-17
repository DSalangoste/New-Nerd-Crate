ActiveAdmin.register Category do
  permit_params :name, :description, crate_type_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column "Crate Types" do |category|
      category.crate_types.map(&:name).join(", ")
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row "Crate Types" do |category|
        category.crate_types.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :crate_type_ids, as: :select, collection: CrateType.all, 
              input_html: { multiple: true }, label: "Crate Types"
    end
    f.actions
  end
end 