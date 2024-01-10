class Admin::BookingsController < Admin::Base
  before_action :admin_login_required

  def update
    @customer = Customer.find(params[:customer_id])
    @booking = @customer.bookings.find(params[:id])
    @booking.booking_seat_flights.each do |booking_seat_flight|
      booking_seat_flight.update(checkin: 1)
    end
    if @booking.save
      redirect_to @customer, notice: t("bookings.booking_success")
    else
      redirect_to @customer, notice: t("bookings.checkin_failed")
    end
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    @booking = @customer.bookings.find(params[:id])
    @booking.destroy
    redirect_to @customer, notice: t("bookings.deleted")
  end
end
