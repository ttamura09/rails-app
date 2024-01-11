class Air::FlightsController < Air::Base
  before_action :air_login_required

  def show
    @flight = Flight.find(params[:id])
  end

  def new
    @flights = Flight.search(params)
    if params[:origin].present? && params[:destination].present? && params[:origin] == params[:destination]
      flash[:notice] = t("flights.flash.different_airports")
    else
      flash.clear
    end
    # @flights = Flight.order("id").where(operation: 1)
    # @flights = @flights.select { |flight| flight.bookings.size > 0 }

    @flight = Flight.new
  end

  def create
    @flight = Flight.new(flight_params)
    @flight.airline_id = current_airline.id

    if @flight.origin_id == @flight.destination_id
      flash[:notice] = t("flights.table.different_airports")
    end
    if @flight.origin_id != @flight.destination_id && @flight.save
      redirect_to [:new, :air, :flight], notice: t("flights.table.flight_added")
    else
      @flights = Flight.order("id")
      @flights = @flights.select { |flight| flight.bookings.size > 0 }
      render "new"
    end
  end

  def update
    @flight = Flight.find(params[:id])
    @flight.operation = 0
    if @flight.save
      redirect_to [:new, :air, :flight], notice: "欠航完了"
    else
      redirect_to [:new, :air, :flight], notice: "欠航失敗"
    end
  end
end

# def update
#   @customer = Customer.find(params[:customer_id])
#   @booking = @customer.bookings.find(params[:id])
#   @booking.booking_seat_flights.each do |booking_seat_flight|
#     booking_seat_flight.update(checkin: 1)
#   end
#   if @booking.save
#     redirect_to @customer, notice: t("bookings.booking_success")
#   else
#     redirect_to @customer, notice: t("bookings.checkin_failed")
#   end
# end

private def flight_params
  params.require(:flight).permit(
    :name, :airmodel_id,
    :departure_date, :departure_time,
    :arrival_date, :arrival_time,
    :origin_id, :destination_id,
    :operation, :price
  )
end
