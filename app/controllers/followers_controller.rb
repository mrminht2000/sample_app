class FollowersController < ApplicationController
  before_action :logged_in_user, :find_user_id

  def index
    @title = t "follow.followers"
    @users = @user.followers.page(params[:page])
                  .per Settings.page.followers
    render :show_follow
  end
end
