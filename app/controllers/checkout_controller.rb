class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :ensure_cart_not_empty
  before_action :set_default_addresses
  include CartManager

  def index
    @order = Order.new
    @cart_items = current_cart
    Rails.logger.debug "Default shipping address: #{@default_shipping_address.inspect}"
    Rails.logger.debug "Default billing address: #{@default_billing_address.inspect}"
  end

  def create
    Rails.logger.debug "=== CHECKOUT CREATE ACTION STARTED ==="
    Rails.logger.debug "Checkout params: #{params.inspect}"
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "Current user ID: #{current_user.id}"
    Rails.logger.debug "Cart items: #{current_cart.inspect}"
    Rails.logger.debug "Session cart: #{session[:cart].inspect}"
    
    unless current_cart.present? && current_cart.any?
      Rails.logger.error "Cart is empty or not present"
      flash[:error] = "Your cart is empty"
      redirect_to cart_path and return
    end

    # Validate required parameters
    unless params[:shipping_address].present? && params[:billing_address].present? && params[:shipping_method].present?
      Rails.logger.error "Missing required parameters"
      Rails.logger.error "Shipping address: #{params[:shipping_address].inspect}"
      Rails.logger.error "Billing address: #{params[:billing_address].inspect}"
      Rails.logger.error "Shipping method: #{params[:shipping_method].inspect}"
      flash[:error] = "Missing required information. Please fill out all fields."
      redirect_to checkout_index_path and return
    end

    @order = Order.new(
      user: current_user,
      status: 'pending',
      payment_status: 'pending',
      shipping_method: params[:shipping_method]
    )

    begin
      ActiveRecord::Base.transaction do
        Rails.logger.debug "Saving order: #{@order.inspect}"
        @order.save!
        Rails.logger.debug "Order saved successfully with ID: #{@order.id}"
        
        # Find province by code
        province = Province.find_by(code: params[:shipping_address][:state])
        if province.nil?
          Rails.logger.error "Province not found with code: #{params[:shipping_address][:state]}"
          raise "Province not found with code: #{params[:shipping_address][:state]}"
        end
        Rails.logger.debug "Found shipping province: #{province.inspect}"
        
        # Create shipping address
        shipping_address = @order.create_shipping_address!(
          user: current_user,
          first_name: params[:shipping_address][:first_name],
          last_name: params[:shipping_address][:last_name],
          address_line_1: params[:shipping_address][:address_line_1],
          city: params[:shipping_address][:city],
          province: province,
          postal_code: params[:shipping_address][:postal_code],
          country: 'Canada',
          phone: params[:shipping_address][:phone],
          address_type: 'shipping'
        )
        Rails.logger.debug "Created shipping address: #{shipping_address.inspect}"

        # Find province by code for billing address
        billing_province = Province.find_by(code: params[:billing_address][:state])
        if billing_province.nil?
          Rails.logger.error "Province not found with code: #{params[:billing_address][:state]}"
          raise "Province not found with code: #{params[:billing_address][:state]}"
        end
        Rails.logger.debug "Found billing province: #{billing_province.inspect}"
        
        # Create billing address
        billing_address = @order.create_billing_address!(
          user: current_user,
          first_name: params[:billing_address][:first_name],
          last_name: params[:billing_address][:last_name],
          address_line_1: params[:billing_address][:address_line_1],
          city: params[:billing_address][:city],
          province: billing_province,
          postal_code: params[:billing_address][:postal_code],
          country: 'Canada',
          phone: params[:billing_address][:phone],
          address_type: 'billing'
        )
        Rails.logger.debug "Created billing address: #{billing_address.inspect}"
        
        # Create order items
        current_cart.each do |item|
          begin
            Rails.logger.debug "Processing cart item: #{item.inspect}"
            crate_type = CrateType.find(item["crate_type_id"].to_i)
            Rails.logger.debug "Found crate type: #{crate_type.inspect}"
            order_item = @order.order_items.create!(
              crate_type: crate_type,
              quantity: item["quantity"].to_i,
              price_cents: (crate_type.price * 100).to_i
            )
            Rails.logger.debug "Created order item: #{order_item.inspect}"
          rescue => e
            Rails.logger.error "Error creating order item: #{e.message}"
            Rails.logger.error "Item data: #{item.inspect}"
            raise "Error creating order item: #{e.message}"
          end
        end

        # Calculate totals
        @order.calculate_totals
        Rails.logger.debug "Calculated totals: subtotal=#{@order.subtotal_cents}, tax=#{@order.tax_cents}, shipping=#{@order.shipping_cents}, total=#{@order.total_cents}"
        @order.save!
        
        # Clear the cart after successful order creation
        clear_cart
        Rails.logger.debug "Order created successfully: #{@order.inspect}"
        Rails.logger.debug "=== CHECKOUT CREATE ACTION COMPLETED SUCCESSFULLY ==="
      end

      redirect_to order_path(@order), notice: 'Order created successfully!'
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Error creating order: #{e.message}"
      Rails.logger.error "Order errors: #{@order.errors.full_messages.join(', ')}"
      flash[:error] = "Error creating order: #{e.message}"
      redirect_to checkout_index_path
    rescue StandardError => e
      Rails.logger.error "Unexpected error creating order: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash[:error] = "An unexpected error occurred. Please try again."
      redirect_to checkout_index_path
    end
  end

  private

  def set_cart
    @cart_items = current_cart
  end

  def ensure_cart_not_empty
    if current_cart.empty?
      redirect_to cart_path, alert: 'Your cart is empty'
    end
  end

  def set_default_addresses
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "User addresses: #{current_user.addresses.inspect}"
    
    # Find default shipping address
    @default_shipping_address = current_user.addresses.find_by(address_type: 'shipping', default: true)
    # If no default shipping address, get the first shipping address
    @default_shipping_address ||= current_user.addresses.find_by(address_type: 'shipping')
    
    # Find default billing address
    @default_billing_address = current_user.addresses.find_by(address_type: 'billing', default: true)
    # If no default billing address, get the first billing address
    @default_billing_address ||= current_user.addresses.find_by(address_type: 'billing')
    
    Rails.logger.debug "Found shipping address: #{@default_shipping_address.inspect}"
    Rails.logger.debug "Found billing address: #{@default_billing_address.inspect}"
  end
end 