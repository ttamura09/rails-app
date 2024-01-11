class FlightsController < ApplicationController
  def index
    @flights = Flight.search(params).operation
    if !params[:origin].present? && !params[:destination].present?
      flash[:notice] = t("flights.flash.select_origin_and_destination")
    elsif !params[:origin].present?
      flash[:notice] = t("flights.flash.select_origin")
    elsif !params[:destination].present?
      flash[:notice] = t("flights.flash.select_destination")
    elsif params[:origin] == params[:destination]
      flash[:notice] = t("flights.flash.different_airports")
    else
      flash.clear
    end
  end
end