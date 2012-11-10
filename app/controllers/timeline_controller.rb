class TimelineController < ApplicationController
  
  before_filter :require_signed_in, only: [:index]
  
  TWEETS_PER_PAGE = 5
  
  def index
    @user = current_user
    # @tweets = @user.tweets.all(order: "created_at DESC").paginate
    @tweets = Tweet.paginate(page: params[:page], per_page: TWEETS_PER_PAGE)
  end
  
end
