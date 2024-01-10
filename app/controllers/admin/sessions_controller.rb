class Admin::SessionsController < Admin::Base
  def new
  end

  def create
    administrator = Administrator.find_by(login_name: params[:login_name])

    if administrator&.authenticate(params[:password])
      cookies.signed[:administrator_id] = { value: administrator.id, expires: 1.day.from_now }
      redirect_to [:admin, :root]
    else
      flash.alert = t("login_error_message")
      redirect_to [:new, :admin, :session]
    end
  end

  def destroy
    cookies.delete(:administrator_id)
    redirect_to [:new, :admin, :session]
  end
end
