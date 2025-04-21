class CartsController < ApplicationController
  include CartManager
  # Remove or skip any authentication checks if they exist
  # skip_before_action :authenticate_user!, if: :devise_controller? # Remove this if it exists

  def show
    @cart_items = current_cart
    @cart_total = cart_total
  end

  def add
    crate_type_id = params[:crate_type_id]
    quantity = (params[:quantity] || 1).to_i

    add_to_cart(crate_type_id, quantity)
    flash[:notice] = "Added to cart successfully!"
    
    redirect_back(fallback_location: root_path)
  end

  def remove
    remove_from_cart(params[:index].to_i)
    flash[:notice] = "Item removed from cart"
    
    redirect_to cart_path
  end

  def update
    index = params[:index].to_i
    quantity = params[:quantity].to_i
    
    if quantity > 0
      current_cart[index]["quantity"] = quantity
      session[:cart] = current_cart
      flash[:notice] = "Quantity updated"
    else
      remove_from_cart(index)
      flash[:notice] = "Item removed from cart"
    end
    
    redirect_to cart_path
  end
end 