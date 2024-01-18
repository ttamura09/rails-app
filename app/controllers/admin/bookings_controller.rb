class Admin::BookingsController < Admin::Base
  before_action :admin_login_required

  def update
    @booking_seat_flight = BookingSeatFlight.find(params[:booking_seat_flight_id])
    if @booking_seat_flight.update(checkin: true)
      redirect_to @booking_seat_flight.booking.customer, notice: t("bookings.checkin_success")
    else
      redirect_to @booking_seat_flight.booking.customer, notice: t("bookings.checkin_failed")
    end
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    @booking = @customer.bookings.find_by(id: params[:id])
    @booking&.destroy
    redirect_to @customer, notice: t("bookings.deleted")
  end
end
