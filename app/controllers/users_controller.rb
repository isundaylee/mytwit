class UsersController < ApplicationController
  
  before_filter :require_admin, only: [:index, :destroy]
  before_filter :require_signed_in, only: [:edit, :update, :edit_avatar, :update_avatar]
  around_filter :rescue_user_not_found, only: [:destroy, :edit, :update, :show, :edit_avatar, :update_avatar]
  
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
  
  def show
    @user = User.find(params[:id])
  end
  
  def edit_avatar
    @user = User.find(params[:id])
    require_admin unless @user == current_user
  end
  
  def update_avatar
    @user = User.find(params[:id])
    require_admin unless @user == current_user
    @user.avatar = params[:user][:avatar]
    if @user.save validate: false
      flash[:success] = 'You have successfully changed your avatar! '
      sign_in @user
    else
      flash[:error] = @user.errors.full_messages.join('<br />').html_safe
    end

    redirect_to edit_avatar_user_url(@user)
  end
  
  private
  
    def rescue_user_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Invalid user. "
      redirect_to root_url
    end
  
end
