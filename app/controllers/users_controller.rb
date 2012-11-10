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
    redirect_to users_path
  end
  
  def create
    @user = User.new(params[:user])
    
    if @user.save then
      redirect_to users_path
    else
      render 'new'
    end
  end
  
end
