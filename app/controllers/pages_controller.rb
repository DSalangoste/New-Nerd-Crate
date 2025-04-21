class PagesController < ApplicationController
  def about
    @page = StaticPage.find_by(slug: 'about')
    render_404 unless @page
  end

  def contact
    @page = StaticPage.find_by(slug: 'contact')
    render_404 unless @page
  end

  private

  def render_404
    render file: Rails.root.join('public', '404.html'), status: :not_found, layout: false
  end
end
