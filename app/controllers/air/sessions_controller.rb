class Air::SessionsController < Air::Base
  def new
  end

  def create
    airline = Airline.find_by(login_name: params[:login_name])

    if airline&.authenticate(params[:password])
      cookies.signed[:airline_id] = { value: airline.id, expires: 1.day.from_now }
      redirect_to [:air, :root]
    else
      flash.alert = t("login_error_message")
      redirect_to [:new, :air, :session]
    end
  end

  def destroy
    cookies.delete(:airline_id)
    redirect_to :root
  end
end
