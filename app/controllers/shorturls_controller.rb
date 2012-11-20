class ShorturlsController < ApplicationController

  def goto
    abbrev = params[:abbrev]
    logger.debug abbrev
    if abbrev.nil? or abbrev.empty?
      flash[:error] = 'Invalid shorturl provided. '
      redirect_to root_url
      return
    end
    shorturl = Shorturl.find_by_abbrev(abbrev)
    if shorturl.nil?
      flash[:error] = 'Shorturl not found. '
      redirect_to root_url
      return
    else
      redirect_to shorturl.url
      return
    end
  end

  private

    def generate_hash
      SecureRandom.hex(3)
    end

end
