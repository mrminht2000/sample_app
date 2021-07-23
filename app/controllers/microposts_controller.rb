class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :build_micropost, only: :create

  def create
    if @micropost.save
      flash[:success] = t "micropost.created"
      return redirect_to root_url
    end

    @feed_items = current_user.feed.all.page(params[:page])
                              .per Settings.page.feed
    flash[:danger] = t "micropost.fail"
    render "static_pages/home"
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost.deleted"
      return redirect_to request.referer || root_url
    end

    flash[:danger] = t "micropost.del_fail"
    render "static_pages/home"
  end

  private

  def micropost_params
    params.require(:micropost).permit Micropost::MICRO_PARAMS
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "please_login"
    redirect_to login_url
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return unless @micropost.nil?

    flash[:danger] = t "not_found"
    redirect_to root_url
  end

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params[:micropost][:image]
  end
end
