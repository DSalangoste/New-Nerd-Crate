ActiveAdmin.register Order do
  menu priority: 3

  permit_params :user_id, :status, :payment_status, :payment_intent_id, 
                :payment_method_id, :subtotal_cents, :tax_cents, :shipping_cents, 
                :total_cents, :shipping_method, :notes, :completed_at

  scope :all
  scope :completed
  scope :pending
  scope :processing

  form do |f|
    f.inputs do
      f.input :user
      f.input :status, as: :select, collection: %w[cart pending processing completed cancelled]
      f.input :payment_status, as: :select, collection: %w[pending paid failed refunded]
      f.input :shipping_method, as: :select, collection: %w[standard express]
      f.input :notes
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :total do |order|
      number_to_currency(order.total_cents / 100.0)
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :status
      row :payment_status
      row :created_at
      row :completed_at
      row :shipping_method
      row :notes
      row :payment do |order|
        if order.payment
          "#{order.payment.payment_method} - #{order.payment.transaction_id}"
        end
      end
    end

    panel "Order Items" do
      table_for order.order_items do
        column :crate_type
        column :quantity
        column :price do |item|
          number_to_currency(item.price_cents / 100.0)
        end
        column :total do |item|
          number_to_currency(item.total_cents / 100.0)
        end
      end
    end

    panel "Order Totals" do
      attributes_table_for order do
        row :subtotal do
          number_to_currency(order.subtotal_cents / 100.0)
        end
        row :tax do
          number_to_currency(order.tax_cents / 100.0)
        end
        row :shipping do
          number_to_currency(order.shipping_cents / 100.0)
        end
        row :total do
          number_to_currency(order.total_cents / 100.0)
        end
      end
    end

    panel "Shipping Address" do
      if order.shipping_address.present?
        attributes_table_for order.shipping_address do
          row :full_name
          row :full_address
          row :phone
        end
      else
        para "No shipping address provided"
      end
    end
  end

  filter :user
  filter :status
  filter :total_cents
  filter :created_at
  filter :completed_at

  member_action :mark_as_shipped, method: :put do
    resource.update(status: :shipped)
    redirect_to resource_path, notice: "Order marked as shipped"
  end

  action_item :ship, only: :show do
    if resource.paid?
      link_to 'Mark as Shipped', mark_as_shipped_admin_order_path(resource), method: :put
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :user_id, :crate_type_id, :status, :total_price
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :crate_type_id, :status, :total_price]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
