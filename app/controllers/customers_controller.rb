class CustomersController < Admin::Base
  before_action :admin_login_required

  def index
    if params[:login_name]
      @customers = Customer.where(login_name: params[:login_name])
    else
      @customers = Customer.order("id")
    end
  end

  def show
    @customer = Customer.find(params[:id])
    @bookings = @customer.bookings
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    redirect_to :customers, notice: t("account.deleted")
  end
end
