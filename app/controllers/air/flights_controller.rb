class Air::FlightsController < Air::Base
  before_action :air_login_required

  def show
    @flight = Flight.find(params[:id])
  end

  def new
    @bookings = Booking.order("id").page(params[:page]).per(30)
    @flights = Flight.search(params).page(params[:page]).per(30)
    if params[:origin].present? && params[:destination].present? && params[:origin] == params[:destination]
      flash.now[:notice] = t("flights.flash.different_airports")
    end
    @flight = Flight.new
  end

  def create
    @flight = Flight.new(flight_params)
    @flight.airline_id = current_airline.id

    if @flight.origin_id == @flight.destination_id
      flash.now[:notice] = t("flights.table.different_airports")
    end
    if @flight.origin_id != @flight.destination_id && @flight.save
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
      redirect_to [:new, :air, :flight], notice: "欠航完了"
    else
      redirect_to [:new, :air, :flight], notice: "欠航失敗"
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
