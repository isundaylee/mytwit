class UsersController < ApplicationController
  
  before_filter :require_admin, only: [:destroy]
  before_filter :require_signed_in, only: [:edit]
  
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
  
  def edit
    @user = User.find(params[:id])
    require_admin unless @user == current_user
  end
  
  def update
    @user = User.find(params[:id])
    require_admin unless @user == current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile successfully updated. "
      sign_in @user
      redirect_to root_url
    else
      render 'edit'
    end
  end
  
end
