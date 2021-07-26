class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find params[:followed_id]
    @user ? current_user.follow(@user) : flash[:danger] = t("not_found")
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    @user ? current_user.unfollow(@user) : flash[:dander] = t("not_found")
  end
end
