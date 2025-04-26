class ApplicationController < ActionController::Base
  include CartManager
  include TaxCalculator
  helper_method :current_cart, :cart_total, :calculate_tax_for_cart, :calculate_shipping_cost  # This makes methods available in views
end
