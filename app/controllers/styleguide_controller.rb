class StyleguideController < ApplicationController
  layout 'styleguide.html.erb'

  def show
    @page_title = 'Styleguide'
  end

  def article_page
    @page_title = 'Article demo page'
  end

  def home_page
    @page_title = 'Homepage demo page'
  end
end
