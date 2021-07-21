class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    unless user&.authenticate(params[:session][:password])
      flash.now[:danger] = t "invalid_login"
      return render :new
    end

    unless user.activated?
      flash[:warning] = t "account_not_actived"
      return redirect_to root_url
    end

    login user
  end

  def destroy
    log_out
    redirect_to root_url
  end

  def login user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end
end
