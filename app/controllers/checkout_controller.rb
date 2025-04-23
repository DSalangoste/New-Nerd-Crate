class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :ensure_cart_not_empty
  before_action :set_default_addresses

  def index
    @order = Order.new
    @cart_items = session[:cart] || []
  end

  def create
    @order = Order.new(
      user: current_user,
      status: :pending,
      payment_status: 'pending',
      shipping_method: params[:shipping_method]
    )

    cart_items = session[:cart] || []
    
    ActiveRecord::Base.transaction do
      @order.save!
      
      # Create shipping address
      @order.create_shipping_address!(
        user: current_user,
        first_name: params[:shipping_address][:first_name],
        last_name: params[:shipping_address][:last_name],
        address_line_1: params[:shipping_address][:address_line_1],
        city: params[:shipping_address][:city],
        province: Province.find_by(code: params[:shipping_address][:state]),
        postal_code: params[:shipping_address][:postal_code],
        country: 'Canada',
        phone: params[:shipping_address][:phone],
        address_type: 'shipping'
      )

      # Create billing address
      @order.create_billing_address!(
        user: current_user,
        first_name: params[:billing_address][:first_name],
        last_name: params[:billing_address][:last_name],
        address_line_1: params[:billing_address][:address_line_1],
        city: params[:billing_address][:city],
        province: Province.find_by(code: params[:billing_address][:state]),
        postal_code: params[:billing_address][:postal_code],
        country: 'Canada',
        phone: params[:billing_address][:phone],
        address_type: 'billing'
      )
      
      cart_items.each do |item|
        crate_type = CrateType.find(item["crate_type_id"].to_i)
        @order.order_items.create!(
          crate_type: crate_type,
          quantity: item["quantity"].to_i,
          price_cents: crate_type.price * 100
        )
      end

      @order.calculate_totals
      @order.save!
      
      # Clear the cart after successful order creation
      session[:cart] = []
    end

    redirect_to order_path(@order), notice: 'Order created successfully!'
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Error creating order: #{e.message}"
    redirect_to checkout_index_path
  end

  private

  def set_cart
    @cart_items = session[:cart] || []
  end

  def ensure_cart_not_empty
    if @cart_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty'
    end
  end

  def set_default_addresses
    @default_shipping_address = current_user.addresses.find_by(address_type: 'shipping')
    @default_billing_address = current_user.addresses.find_by(address_type: 'billing')
  end
end 