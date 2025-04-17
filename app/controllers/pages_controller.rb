class PagesController < ApplicationController
  def about
  end

  def contact
  end

  private

  def render_404
    render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false
  end
end
