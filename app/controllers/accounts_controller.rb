class AccountsController < ApplicationController
  before_action :login_required, except: [:new, :create]

  def show
    @customer = current_customer
    @bookings = @customer.bookings
    @bookings_history = @bookings.select { |booking| booking.flight.departure_date < Date.today }
    @bookings_information = @bookings.select { |booking| booking.flight.departure_date >= Date.today }
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = current_customer
  end

  def create
    @customer = Customer.new(account_params)
    if @customer.save
      cookies.signed[:customer_id] = { value: @customer.id, expires: 1.day.from_now }
      redirect_to :root, notice: t("account.created")
    else
      render "new"
    end
  end

  def update
    @customer = current_customer
    @customer.assign_attributes(account_params)
    if @customer.save
      redirect_to :account, notice: t("account.updated")
    else
      render "edit"
    end
  end

  def destroy
    @customer = current_customer
    @customer&.destroy
    redirect_to :root, notice: t("account.deleted")
  end

  private def account_params
    params.require(:account).permit(:name, :alph_name, :login_name, :sex, :birthday, :password, :email)
  end
end
