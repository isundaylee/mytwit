class SessionsController < ApplicationController

  def new
  end
  
  def create
    session = params[:session]
    user = User.find_by_email(session[:email].downcase)
    if user && user.authenticate(session[:password])
      sign_in user
      flash[:success] = "Login succeeded. "
      redirect_to root_path
    else
      @errors = ['Invalid email / password combination. ']; 
      render 'new'
    end
  end
  
  def destroy
    sign_out
    flash[:success] = "You've successfully logged out. "
    redirect_to root_url
  end

end
