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

    @user.send_mail_activate
    flash[:info] = t "check_mail"
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def edit; end

  def show
    @microposts = @user.microposts.page(params[:page])
                       .per Settings.page.microposts
  end

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

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

end
