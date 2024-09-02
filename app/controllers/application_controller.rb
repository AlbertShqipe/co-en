class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  # Optional: To make sure URLs include the locale
  def default_url_options
    { locale: I18n.locale }
  end
end
