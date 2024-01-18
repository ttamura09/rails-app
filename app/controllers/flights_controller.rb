class FlightsController < ApplicationController
  def index
    @flights = Flight.search(params).operation.page(params[:page]).per(10)
    if params[:seat_class].present?
      bookable_flights_count = @flights.count { |flight| flight.calc_seat_nums(params[:seat_class]) > 0 }
    else
      bookable_flights_count = @flights.count { |flight| flight.calc_seat_nums(params[:seat_class]) > 0 }
    end
    if bookable_flights_count == 0
      flash.now[:notice] = t("flights.no_flights")
    end
    if !params[:origin].present? && !params[:destination].present?
      flash[:notice] = t("flights.flash.select_origin_and_destination")
      redirect_to :root
    elsif !params[:origin].present?
      flash[:notice] = t("flights.flash.select_origin")
      redirect_to :root
    elsif !params[:destination].present?
      flash[:notice] = t("flights.flash.select_destination")
      redirect_to :root
    elsif params[:origin] == params[:destination]
      flash[:notice] = t("flights.flash.different_airports")
      redirect_to :root
    end
  end
end