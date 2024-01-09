class FlightsController < ApplicationController
  def index
    @flights = Flight.search(params)
  end
end
