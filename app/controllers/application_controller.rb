class ApplicationController < ActionController::Base
  before_action :set_locale

  class LoginRequired < StandardError; end

  class Forbidden < StandardError; end

  private def login_required
    raise LoginRequired unless current_customer
  end
  private def current_customer
    Customer.find_by(id: cookies.signed[:customer_id]) if cookies.signed[:customer_id]
  end
  helper_method :current_customer

  private def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
