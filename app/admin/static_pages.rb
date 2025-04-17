ActiveAdmin.register_page "Static Pages" do
  menu label: "Static Pages", priority: 2

  content title: "Edit Static Pages" do
    render partial: 'admin/static_pages/form'
  end

  controller do
    def update
      about_content = params[:static_pages][:about]
      contact_content = params[:static_pages][:contact]
      
      File.write(Rails.root.join('app', 'views', 'pages', '_about_content.html.erb'), about_content)
      File.write(Rails.root.join('app', 'views', 'pages', '_contact_content.html.erb'), contact_content)
      
      redirect_to admin_static_pages_path, notice: 'Pages updated successfully'
    end
  end

  action_item :view_site do
    link_to "View Site", "/", target: '_blank'
  end

  page_action :update, method: :post
end
