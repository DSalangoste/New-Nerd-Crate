ActiveAdmin.register StaticPage do
  menu label: "Static Pages", priority: 2

  permit_params :title, :slug, :content

  index do
    selectable_column
    id_column
    column :title
    column :slug
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :slug
      f.input :content, as: :text, input_html: { rows: 20 }
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :slug
      row :content do |page|
        raw page.content
      end
    end
  end

  action_item :view_site do
    link_to "View Site", "/", target: '_blank'
  end
end
