class BookingsController < ApplicationController
  before_action :login_required
  def index
    @bookings = current_customer.bookings
    @past_bookings = @bookings.select { |booking| booking.flight.departure_date < Date.today }
    @future_bookings = @bookings.select { |booking| booking.flight.departure_date >= Date.today }
  end

  def show
    @booking = Booking.find(params[:id])
    @number_of_passengers = @booking.seats.size
  end

  def new
    @flight = Flight.find(params[:flight_id])
    @booking = Booking.new
    @seat_class = params[:seat_class]
    @number_of_passengers = params[:number_of_passengers].to_i
  end

  def edit
    @account = current_customer
    @booking = @account.bookings.find(params[:id])
  end

  def create
    @booking = Booking.new(booking_params)
    @flight = Flight.find(params[:flight_id])
    @seat_class = params[:booking][:seat_class]
    @number_of_passengers = params[:booking][:number_of_passengers].to_i
    @booking.number_of_passengers = @number_of_passengers
    selected_seat_count = (booking_params[:seat_ids] ? booking_params[:seat_ids].size : 0)
    if @number_of_passengers != selected_seat_count
      flash[:notice] = "選択された席の数が予約人数と一致していません。"
    end

    @booking.customer = current_customer
    @booking.flight = @flight
    @booking.total_price = @flight.sum_price(@seat_class) * @number_of_passengers
    if @number_of_passengers == selected_seat_count && @booking.save
      @booking.booking_seat_flights.each do |booking_seat_flight|
        booking_seat_flight.update(flight_id: @flight.id)
      end
      redirect_to :root, notice: "予約が完了しました。"
    else
      render "new"
    end
  end

  def update
    @account = current_customer
    @booking = @account.bookings.find(params[:id])
    @booking.booking_seat_flights.each do |booking_seat_flight|
      booking_seat_flight.update(checkin: 1)
    end
    if @booking.save
      redirect_to [:account, @booking], notice: "チェックインを完了しました。"
    else
      render "edit"
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
