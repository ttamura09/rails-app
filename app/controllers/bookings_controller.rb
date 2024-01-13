class BookingsController < ApplicationController
  before_action :login_required

  def index
    @bookings = current_customer.bookings
    @bookings_history = @bookings.select { |booking| booking.flight.departure_date < Date.today }
    @bookings_information = @bookings.select { |booking| booking.flight.departure_date >= Date.today }
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

    @number_of_passengers.times { @booking.booking_seat_flights.build }
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

    @booking.customer = current_customer
    @booking.flight = @flight
    @booking.total_price = @flight.sum_price(@seat_class) * @number_of_passengers

    seat_ids = booking_params[:booking_seat_flights_attributes].values.map { |val| val[:seat_id] }
    if seat_ids.any?(&:blank?) || seat_ids.uniq.size != @number_of_passengers
      flash.now[:notice] = t("bookings.seat_mismatch")
      render "new"
    elsif @booking.save
      redirect_to :root, notice: t("bookings.booking_success")
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
      redirect_to [:account, @booking], notice: t("bookings.checkin_success")
    else
      render "edit"
    end
  end

  def destroy
    @booking = current_customer.bookings.find_by(params[:id])
    @booking&.destroy
    redirect_to [:account, :bookings], notice: t("bookings.deleted")
  end

  def booking_params
    params.require(:booking).permit(
      :payment_method,
      booking_seat_flights_attributes: [:seat_id, :passenger_name, :passenger_birthday, :passenger_telephone_number, :passenger_email, :flight_id]
    )
  end
end
