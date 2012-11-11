class TimelineController < ApplicationController
  
  before_filter :require_signed_in, only: [:index]
  
  TWEETS_PER_PAGE = 5
  
  def index
    @user = current_user
    # @tweets = @user.tweets.all(order: "created_at DESC").paginate
    sql = "user_id = #{@user.id}"
    @user.followees.each do |f|
      part = "user_id = #{f.id}"
      sql += " OR " + part
    end
    @tweets = Tweet.where(sql).order('created_at DESC').paginate(page: params[:page], per_page: TWEETS_PER_PAGE)
  end
  
  def show
    @user = User.find(params[:id])
    @tweets = Tweet.where(user_id: @user.id).order('created_at DESC').paginate(page: params[:page], per_page: TWEETS_PER_PAGE)
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invalid user. "
      redirect_to root_url
  end
  
end
