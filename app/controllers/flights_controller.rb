class FlightsController < ApplicationController
  before_action :login_required, only: [:show]

  def index
    @flights = Flight.search(params)
  end

  def show
  end
end
