class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_locale

  private

  def set_locale
    I18n.locale = if %w[en fr].include?(params[:locale])
      params[:locale]
    else
      I18n.default_locale
    end
  end

  # Include locale in all generated URLs as a path segment
  def default_url_options
    { locale: I18n.locale }
    # If you prefer to *hide* the segment for the default locale, use:
    # I18n.locale == I18n.default_locale ? {} : { locale: I18n.locale }
  end
end
