class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :ensure_cart_not_empty

  def index
    @order = Order.new
    @cart_items = session[:cart] || []
  end

  def create
    @order = Order.new(
      user: current_user,
      status: 'pending',
      payment_status: 'pending'
    )

    cart_items = session[:cart] || []
    
    ActiveRecord::Base.transaction do
      @order.save!
      
      cart_items.each do |item|
        crate_type = CrateType.find(item["crate_type_id"].to_i)
        @order.order_items.create!(
          crate_type: crate_type,
          quantity: item["quantity"].to_i,
          price_cents: crate_type.price_cents
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
    redirect_to checkout_path
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
end 