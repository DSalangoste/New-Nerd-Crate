class HomeController < ApplicationController
  def index
    @crate_types = CrateType.includes(:categories).all
  end
end
