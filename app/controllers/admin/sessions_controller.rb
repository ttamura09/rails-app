class Admin::SessionsController < Admin::Base
  def new
  end
  def create
    administrator = Administrator.find_by(login_name: params[:login_name])

    if administrator&.authenticate(params[:password])
      cookies.signed[:administrator_id] = { value: administrator.id, expires: 1.day.from_now }
    else
      flash.alert = "ログイン名とパスワードが一致しません"
    end
    redirect_to [:admin, :root]
  end

  def destroy
    cookies.delete(:administrator_id)
    redirect_to :root
  end
end
