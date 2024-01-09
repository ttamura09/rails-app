class SessionsController < ApplicationController
  def create
    customer = Customer.find_by(login_name: params[:login_name])

    if customer&.authenticate(params[:password])
      cookies.signed[:customer_id] = { value: customer.id, expires: 1.day.from_now }
      redirect_to :root
    else
      flash.alert = "ログイン名とパスワードが一致しません"
      redirect_to [:new, :session]
    end
  end

  def destroy
    cookies.delete(:customer_id)
    redirect_to :root
  end
end
