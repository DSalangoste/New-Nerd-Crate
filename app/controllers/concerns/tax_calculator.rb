module TaxCalculator
  extend ActiveSupport::Concern

  private

  def calculate_tax_for_cart(cart_items, province = nil)
    # Calculate subtotal in cents
    subtotal_cents = cart_items.sum do |item|
      crate_type = CrateType.find(item["crate_type_id"].to_i)
      (crate_type.price * 100 * item["quantity"].to_i).to_i
    end
    
    # Get tax rate from province or use default
    tax_rate = if province&.tax_rate.present?
      # Ensure tax_rate is a decimal (e.g., 0.15 for 15%)
      rate = province.tax_rate
      if rate > 1
        rate = rate / 100.0
      end
      rate
    else
      # Default to 10% if no province or tax rate
      0.1
    end
    
    # Calculate tax in cents
    (subtotal_cents * tax_rate).round
  end

  def calculate_shipping_cost(shipping_method)
    case shipping_method
    when 'express'
      1500 # $15 for express
    else
      500  # $5 for standard
    end
  end
end 