class FlightsController < ApplicationController
  def index
    @flights = Flight.search(params).operation.page(params[:page]).per(10)
    bookable_flights_count = @flights.count { |flight| flight.calc_seat_nums(params[:seat_class]) > 0 }
    if bookable_flights_count == 0
      flash[:notice] = t("flights.no_flights")
    end
    if !params[:origin].present? && !params[:destination].present?
      flash[:notice] = t("flights.flash.select_origin_and_destination")
    elsif !params[:origin].present?
      flash[:notice] = t("flights.flash.select_origin")
    elsif !params[:destination].present?
      flash[:notice] = t("flights.flash.select_destination")
    elsif params[:origin] == params[:destination]
      flash[:notice] = t("flights.flash.different_airports")
    else
      # flash.clear
    end
  end
end