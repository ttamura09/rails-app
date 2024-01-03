class FlightsController < ApplicationController
  def index
    @flights = Flight.search(params[:origin],
                             params[:destination],
                             params[:departure_date],
                             params[:min_price],
                             params[:max_price],
                             params[:time],
                             params[:selected],
                             params[:seat_class]
    )
  end

  def show
  end
end
