class ApplicationController < ActionController::Base
  around_action :switch_locale

  class LoginRequired < StandardError; end

  class Forbidden < StandardError; end

  private def login_required
    raise LoginRequired unless current_customer
  end
  private def current_customer
    Customer.find_by(id: cookies.signed[:customer_id]) if cookies.signed[:customer_id]
  end
  helper_method :current_customer

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options(options = {})
    options.merge(locale: locale)
  end
end
