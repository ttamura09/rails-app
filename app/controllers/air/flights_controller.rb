class Air::FlightsController < Air::Base
  before_action :air_login_required

  def show
    @flight = Flight.find(params[:id])
  end

  def new
    @flights = Flight.order("id")
    @flights = @flights.select { |flight| flight.bookings.size > 0 }

    @flight = Flight.new
  end

  def create
    @flight = Flight.new(flight_params)
    @flight.airline_id = current_airline.id

    if @flight.origin_id == @flight.destination_id
      flash[:notice] = "出発地と到着地は異なる空港を指定してください。"
    end
    if @flight.origin_id != @flight.destination_id && @flight.save
      redirect_to [:new, :air, :flight], notice: "フライトを追加しました。"
    else
      @flights = Flight.order("id")
      @flights = @flights.select { |flight| flight.bookings.size > 0 }
      render "new"
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
end
