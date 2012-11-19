class TimelineController < ApplicationController
  
  before_filter :require_signed_in, only: [:index, :updates]
  
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

  def updates
    since = params[:since]
    if since.nil?
      since = 0
    else
      since = since.to_i
    end
    user = current_user
    ids = [user.id]
    user.followees.each do |u|
      ids << u.id
    end
    clause = ids.map { |i| "user_id = #{i}" }.join(" OR ")
    @tweets = Tweet.where(clause).where('created_at > ?', Time.at(since))
    respond_to do |format|
      format.json {
        render json: {
          result: 'success',
          updates: @tweets.count,
          since: since
        }
      }
    end
  end
  
end
