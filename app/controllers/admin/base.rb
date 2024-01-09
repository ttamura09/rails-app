class Admin::Base < ApplicationController
  class AdminLoginRequired < StandardError; end

  private def admin_login_required
    raise AdminLoginRequired unless current_administrator
  end

  private def current_administrator
    Administrator.find_by(id: cookies.signed[:administrator_id]) if cookies.signed[:administrator_id]
  end
  helper_method :current_administrator
end
