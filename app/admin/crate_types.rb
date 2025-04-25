ActiveAdmin.register CrateType do
  permit_params :name, :description, :price, :image, category_ids: []

  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price do |crate|
      number_to_currency(crate.price)
    end
    column :image do |crate|
      if crate.image.attached?
        image_tag url_for(crate.thumbnail)
      else
        "No image"
      end
    end
    column :categories do |crate|
      crate.categories.map(&:name).join(", ")
    end
    column :created_at
    actions
  end

  filter :name
  filter :description
  filter :price
  filter :categories
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :categories, as: :check_boxes
      
      # Image upload with preview
      div class: "image-upload-container", data: { controller: "image-preview" } do
        f.input :image, as: :file, 
                input_html: { 
                  data: { 
                    image_preview_target: "input"
                  }
                },
                hint: f.object.image.attached? ? 
                  image_tag(url_for(f.object.medium), 
                           data: { image_preview_target: "preview" }) : 
                  "No image uploaded"
        
        # Preview container
        div class: "mt-2" do
          if f.object.image.attached?
            image_tag url_for(f.object.medium), 
                      class: "hidden", 
                      data: { image_preview_target: "preview" }
          else
            img src: "", class: "hidden", data: { image_preview_target: "preview" }
          end
        end
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :price do |crate|
        number_to_currency(crate.price)
      end
      row :image do |crate|
        if crate.image.attached?
          image_tag url_for(crate.large)
        else
          "No image"
        end
      end
      row :categories do |crate|
        crate.categories.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
  end
end
