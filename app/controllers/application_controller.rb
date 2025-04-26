class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include CartManager
  helper_method :current_cart  # This makes current_cart available in views
end
