class BookingsController < ApplicationController
  def new
    @flight = Flight.find(params[:flight_id])
    @seats = @flight.airmodel.seats
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @flight = Flight.find(params[:flight_id])

    @booking.customer = current_customer
    @booking.flight = @flight
    @booking.total_price = @flight.sum_price("first")

    if @booking.save
      @booking.booking_seat_flights.each do |booking_seat_flight|
        booking_seat_flight.update(flight_id: @flight.id)
      end
      redirect_to :root, notice: "予約が完了しました。"
    else
      redirect_to :root, notice: "予約に失敗しました..."
    end
  end

  private def booking_params
    params.require(:booking).permit(
      :passenger1_name, :passenger1_birthday, :passenger1_telephone_number, :passenger1_email,
      :passenger2_name, :passenger2_birthday, :passenger2_telephone_number, :passenger2_email,
      :passenger3_name, :passenger3_birthday, :passenger3_telephone_number, :passenger3_email,
      :payment_method, seat_ids: []
    )
  end

end
