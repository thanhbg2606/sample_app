class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::NestedAttributes::TooManyRecords, with: :error_render_method

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".danger")
    redirect_to login_path
  end

  def error_render_method _e
    redirect_to questions_url, alert: _e.to_s
    true
  end
end
