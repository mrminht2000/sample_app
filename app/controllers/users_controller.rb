class UsersController < ApplicationController
  before_action :find_user_id, except: %i(index create new)
  before_action :logged_in_user, except: %i(create new)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.all.page(params[:page]).per Settings.page.index
  end

  def create
    @user = User.new user_params

    return render :new unless @user.save

    log_in @user
    flash[:success] = t "welcome_title"
    redirect_to @user
  end

  def new
    @user = User.new
  end

  def edit; end

  def show; end

  def update
    return render :edit unless @user.update user_params

    flash[:success] = t "profile_updated"
    redirect_to @user
  end

  def destroy
    if current_user != @user && @user.destroy
      flash[:success] = t "user_deleted"
    else
      flash[:danger] = t "delete_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "not_found"
    redirect_to root_path
  end
end
