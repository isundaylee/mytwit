class TweetsController < ApplicationController
  
  before_filter :require_signed_in, only: [:create, :retweet, :repost]
  around_filter :rescue_tweet_not_found, only: [:retweet, :repost]
  
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
  
  def retweet
    @tweet = Tweet.find(params[:id])
    render layout: false
  end

  def repost
    tweet = Tweet.find(params[:id])
    repost_message = params[:repost_message]
    new_tweet = current_user.tweets.build
    if new_tweet.nil? 
      respond_to do |format|
        format.json {
          render json: {
            result: 'failure', 
            error: 'Invalid user. '
          }
        }
      end
    else
      new_tweet.precedent = tweet
      logger.debug tweet.origin
      if tweet.origin.nil?
        new_tweet.origin = tweet
      else
        new_tweet.origin = tweet.origin
      end
      new_tweet.content = repost_message
      if new_tweet.save
        respond_to do |format|
          format.json {
            render json: {
              result: 'success'
            }
          }
        end
      logger.debug 'Hello'
      logger.debug tweet.inspect
      logger.debug new_tweet.inspect
      else
        respond_to do |format|
          format.json {
            render json: {
              result: 'failure', 
              error: new_tweet.errors.full_messages.join("<br />")
            }
          }
        end
      end
    end
  end
  
  private
    def rescue_tweet_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invalid tweet. "
      redirect_to root_url
    end
  
end
