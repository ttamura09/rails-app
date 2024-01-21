class Air::FlightsController < Air::Base
  before_action :air_login_required

  def show
    @flight = Flight.find(params[:id])
  end

  def new
    @bookings = Booking.order("id").page(params[:page]).per(30)
    @flights = Flight.search(params).page(params[:page]).per(30)
    @flight = Flight.new
  end

  def create
    @flight = Flight.new(flight_params)
    @flight.airline_id = current_airline.id

    departure = Time.parse("#{flight_params[:departure_date]} #{flight_params[:departure_time]}")
    arrival = Time.parse("#{flight_params[:arrival_date]} #{flight_params[:arrival_time]}")
    if @flight.origin_id == @flight.destination_id
      flash.now[:notice] = t("flights.table.different_airports")
    elsif departure <= Time.now || arrival <= Time.now
      flash.now[:notice] = t("flights.table.past_date_not_allowed")
    elsif departure >= arrival
      flash.now[:notice] = t("flights.table.departure_before_arrival")
    end

    if @flight.origin_id != @flight.destination_id && (departure > Time.now && arrival > Time.now) && departure < arrival && @flight.save
      redirect_to [:new, :air, :flight], notice: t("flights.table.flight_added")
    else
      @bookings = Booking.order("id").page(params[:page]).per(30)
      @flights = Flight.search(params).page(params[:page]).per(30)
      render "new"
    end
  end

  def update
    @flight = Flight.find(params[:id])
    @flight.operation = 0
    if @flight.save
      redirect_to [:new, :air, :flight], notice: t("flights.table.cancellation_successful")
    else
      redirect_to [:new, :air, :flight], notice: t("flights.table.cancellation_failed")
    end
  end
end

private def flight_params
  params.require(:flight).permit(
    :name, :airmodel_id,
    :departure_date, :departure_time,
    :arrival_date, :arrival_time,
    :origin_id, :destination_id,
    :operation, :price
  )
end
