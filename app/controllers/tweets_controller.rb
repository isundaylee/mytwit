class TweetsController < ApplicationController
  
  before_filter :require_signed_in, only: [:create]
  
  def create
    user = current_user
    tweet = user.tweets.build(params[:tweet]) unless user.nil?
    if tweet.nil?
      flash[:error] = "Invalid user. "
    elsif !tweet.save
      flash[:saved_tweet_content] = params[:tweet][:content]
      flash[:error] = tweet.errors.full_messages.join("<br />").html_safe
    else
      flash[:success] = "Tweet posted! "
    end
    redirect_to timeline_url
  end
  
end
