class CheckoutController < ApplicationController
  include CartManager

  def index
    @cart_items = current_cart.map do |item|
      crate_type = CrateType.find(item["crate_type_id"].to_i)
      {
        crate_type: crate_type,
        quantity: item["quantity"].to_i,
        total: crate_type.price * item["quantity"].to_i
      }
    end
    @cart_total = @cart_items.sum { |item| item[:total] }

    if @cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty"
      return
    end
  end
end 