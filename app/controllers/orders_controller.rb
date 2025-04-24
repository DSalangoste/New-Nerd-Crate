class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "Current user ID: #{current_user.id}"
    Rails.logger.debug "Current user orders count: #{current_user.orders.count}"
    @orders = current_user.orders.includes(:order_items, :shipping_address)
                         .order(created_at: :desc)
    Rails.logger.debug "Found orders: #{@orders.inspect}"
  end

  def show
    @order = current_user.orders.includes(:shipping_address, :billing_address).find(params[:id])
    @order_items = @order.order_items.includes(:crate_type)
  end
end 