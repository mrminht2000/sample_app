class FollowingController < ApplicationController
  before_action :logged_in_user, :find_user_id

  def index
    @title = t "follow.following"
    @users = @user.following.page(params[:page])
                  .per Settings.page.following
    render "users/show_follow"
  end
end
