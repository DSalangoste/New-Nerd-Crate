class ApplicationController < ActionController::Base
  include CartManager
  helper_method :current_cart  # This makes current_cart available in views
end
