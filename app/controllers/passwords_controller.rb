class PasswordsController < ApplicationController
  before_action :login_required

  def show
    redirect_to :account
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    current_password = params[:account][:current_password]

    if current_password.present?
      if @customer.authenticate(current_password)
        @customer.assign_attributes(account_params)
        if @customer.save
          redirect_to :account, notice: t("passwords.changed")
        else
          render "edit"
        end
      else
        @customer.errors.add(:current_password, :wrong)
        render "edit"
      end
    else
      @customer.errors.add(:current_password, :empty)
      render "edit"
    end
  end

  private def account_params
    params.require(:account).permit(:current_password, :password, :password_confirmation)
  end
end
