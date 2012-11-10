class UsersController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User successfully deleted. "
    redirect_to users_url
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save then
      sign_in @user
      redirect_to users_url
    else
      render 'new'
    end
  end
  
end
