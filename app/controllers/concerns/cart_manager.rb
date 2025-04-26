module CartManager
  extend ActiveSupport::Concern

  private

  def current_cart
    session[:cart] ||= []
  end

  def add_to_cart(crate_type_id, quantity = 1)
    # Convert crate_type_id to integer
    crate_type_id = crate_type_id.to_i
    
    # Check if item exists in cart
    existing_item = current_cart.find { |item| item["crate_type_id"].to_i == crate_type_id }
    
    if existing_item
      existing_item["quantity"] += quantity
    else
      current_cart << {
        "crate_type_id" => crate_type_id,
        "quantity" => quantity,
        "added_at" => Time.current
      }
    end
    
    session[:cart] = current_cart
  end

  def remove_from_cart(index)
    current_cart.delete_at(index)
    session[:cart] = current_cart
  end

  def clear_cart
    session[:cart] = []
  end

  def cart_total
    return 0 if current_cart.empty?
    
    # Calculate total in cents to match order calculation
    total_cents = current_cart.sum do |item|
      crate_type = CrateType.find(item["crate_type_id"].to_i)
      (crate_type.price * 100 * item["quantity"].to_i).to_i
    end
    
    # Convert back to dollars for display
    total_cents / 100.0
  end
end 