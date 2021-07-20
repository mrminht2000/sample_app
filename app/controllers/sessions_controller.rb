class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    unless user&.authenticate(params[:session][:password])
      flash.now[:danger] = t "invalid_login"
      return render :new
    end

    log_in user
    redirect_to user
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
