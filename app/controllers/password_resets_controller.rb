class PasswordResetsController < ApplicationController
  before_action :find_user_by_email, :valid_user, only: %i(edit update)
  before_action :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_reset.sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "password_reset.not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("password_reset.cant_empty")
      render :edit
    elsif @user.update user_params
      log_in @user
      flash[:success] = t "password_reset.success"
      redirect_to @user
    else
      flash[:danger] = t "password_reset.fail"
      render :edit
    end
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset.expired"
    redirect_to new_password_reset_url
  end

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end
end
