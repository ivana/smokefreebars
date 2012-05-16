class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    extracted_locale = extract_locale_from_accept_language_header
    extracted_locale = I18n.default_locale unless I18n.available_locales.include? extracted_locale.to_sym
    I18n.locale = params[:locale] || extracted_locale
  end

  private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
