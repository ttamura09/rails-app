class Air::CustomersController < Air::Base
  def show
    @customer = Customer.find(params[:id])
    @bookings = @customer.bookings
  end
end
