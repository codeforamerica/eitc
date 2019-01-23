class ApplicationController < ActionController::Base
  helper_method :template_css_class

  def template_css_class
    'homepage'
  end
end
