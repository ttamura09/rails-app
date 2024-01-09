class Air::Base < ApplicationController
  class AirLoginRequired < StandardError; end

  private def air_login_required
    raise AirLoginRequired unless current_airline
  end

  private def current_airline
    Airline.find_by(id: cookies.signed[:airline_id]) if cookies.signed[:airline_id]
  end
  helper_method :current_airline
end
